# Loads a list of stop words and puts them into a hash
class StopWords
  def initialize
    @contents = Array.new
    files = ['lib/stop_words.txt', 'lib/html_words.txt']
    files.each do |file|
      File.open(file, 'r').readlines.each do |line|
        @contents = @contents | line.split(' ')
      end
    end
    @stop_words = Hash[@contents.collect{|w| [w,true] } ]
  end

  def words
    @stop_words
  end

  def to_s
    @contents
  end
end
