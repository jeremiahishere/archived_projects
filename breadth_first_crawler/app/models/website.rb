class Website < ActiveRecord::Base
  require 'lib/unique_queue.rb'
  require 'thread'
  has_many :website_pages

  def search(string)
    words_not_found = Array.new
    page_counts = {}
    string.split(' ').each do |word|
      current_word = Word.find(:first, :conditions => {:name => word})
      if current_word
        puts "'#{current_word.inspect}'"
        WebsitePage.find(:all, :conditions => {:website_id => self.id}).each do |page|
          puts page.inspect
          count = Phrase.find_by_sql("select count(*) from phrases as a join ordered_words as b on a.id=b.phrase_id join words as c on b.word_id=c.id where a.website_page_id=#{page.id} and c.id=#{current_word.id}").count
          puts count
          if page_counts[page.id]
            page_counts[page.id] += count
          else
            page_counts[page.id] = count
          end
        end
      else
        words_not_found.push(word)
      end
    end
    [page_counts, words_not_found]
  end

  # crawls a website following all links in a breadth first search as long as possible
  #
  # seed_data should be an array of strings starting with /, relative links only
  def crawl_website(*seed_data)
    buffer = UniqueQueue.new
    stop_words = StopWords.new
    mutex = Mutex.new
    # cannot be declared in mutex
    page = ""
    count = 0

    #setup seeding urls
    seeds = seed_data.blank? ? ['/'] : seeds.push('/')
    seeds.each do |seed|
      buffer.push_if_not_duplicate(seed)
    end

    # run the first page outside of a thread to seed the buffer
    # otherwise the main loop will immediately exit
    #
    # add base url here
    mutex.synchronize do
      page = self.url + buffer.pop_first
    end
    urls = process_url(page, stop_words)
    mutex.synchronize do
      urls.each do |url|
        buffer.push_if_not_duplicate(url)
      end
    end
    puts buffer
    mutex.synchronize do
      count += 1
    end
    #process a page, then add each url it found to the buffer
    #stop when no more new urls are found
    while count < 15 and buffer.size > 0 do
      if Thread.list.length < 4
        worker = Thread.new do
          # add base url here
          mutex.synchronize do
            page = self.url + buffer.pop_first
          end
          puts "Thread starting for #{page}"
          urls = process_url(page, stop_words)
          mutex.synchronize do
            urls.each do |url|
              buffer.push_if_not_duplicate(url)
            end
          end
          puts buffer
          mutex.synchronize do
            count += 1
          end
          puts "Thread complete for #{page}"
          Thread.exit
        end
      else
        sleep 15
        puts "Sleeping, no threads available"
      end
    end
    print "processing complete"
    print "buffer: " + buffer.to_s
  end

  # processes a url, saves the content, returns an array of links on the page
  def process_url(url, stop_words)
    #get the contents of the page
    agent = Mechanize.new
    content = agent.get(url)
    #check if the page already exists in the database
    page = WebsitePage.find_or_create_by_url(url, :website_id => self.id, :name => content.title)
    # if it does, delete all its phrase and orderedword information (for now)
    Phrase.find(:all, :conditions => {:website_page_id => page.id}).each do |phrase|
      OrderedWord.delete_all({:phrase_id => phrase.id})
      Phrase.delete(phrase.id)
    end

    #get any links on the page
    urls = get_links(content)
    #save all content to the database
    save_phrases(content, page.id, stop_words)
    return urls
  end

  # gets all the links on the page, returns relative versions of each link
  # this is to stop the crawler from going to other websites
  def get_links(content) 
    #pull any a tags and save to results array
    results = Array.new
    # in certain situations, there is no links method
    # not sure why, looks like the it happens when the document is not html/xml
    if content.respond_to?('links')
      content.links.each do |link|
        href = link.href
        # concerned about links for deletion rather than buttons
        #this is not a very good solution
        if href and ( link.text.downcase != "delete" or link.text.downcase != "destroy")
          # if link starts with / we are fine
          if href.length >= 1 and href[1..1] == "/"
            results.push(href)
          # if link starts with ./, remove the dot
          elsif href.length >= 2 and href[1..2] == "./"
            result.push(href[2..-1])
          # if link starts with the url, remove it 
          elsif href.match(self.url)
            href.gsub!(self.url, '')
            results.push(href) 
          end
          # otherwise, don't use the link
        end
      end
    end
    #return the url results array
    return results
  end

  # gets all of the text objects on the page
  # remove stop words and short words
  # saves word, phrases, ordered words
  def save_phrases(content, page_id, stop_words)
    # pulls all text objects from nokogiri
    # on bad url input, content will not have a search method
    if content.respond_to?('search')
      content.search('//text()').each do |text|
        #puts page_id.to_s + ":" + text.content[1..25]
        working_text = remove_unreasonable_words(text, stop_words)
        # TODO: add code to check if the phrase already exists, and increment a counter on phrase rather than making it twice
        # create a new phrase for the page
        phrase = Phrase.create(:website_page_id => page_id, :name => working_text[0..25])
        #for all the other words
        working_text.split(/\s/).each do |word_name|
          word_name.strip!
          # check if already in the database, add it if not
          word = Word.find_or_create_by_name(word_name)
          # create a new ordered word for the phrase using the current word
          OrderedWord.create(:word_id => word.id, :phrase_id => phrase.id)
        end
      end
    end
  end

  # removes stop words and very short words
  # short words removed to deal with random symbols/characters in the text often used for layout
  def remove_unreasonable_words(text, stop_words)
    working_text = text.content.gsub(/\b\w+\b/) do |word| 
      #(stop_words.words[word.downcase] ? '' : word).squeeze(' ')
      if !stop_words.words[word.downcase] or word.length > 2
        word
      else 
        ""
      end
    end
    working_text.squeeze(' ')
  end
end
