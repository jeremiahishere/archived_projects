class Vindinium

  attr_accessor :games, :turns, :mode, :key, :server, :state, :http_client, :error, :bot, :debug

  def initialize opts
    puts "Opts: #{opts}"
    opts.each_pair do |k,v|
      self.send("#{k}=", v)
    end

    self.http_client = HTTPClient.new
    self.http_client.debug_dev=$stdout if self.debug
    self.server = "http://vindinium.org" if not self.server
  end

  def start

    if arena?
      puts "Connected and waiting for other players..."
    end

    self.state = create_new_game
    
    if self.error
      puts "OOOPS -- couldn't start a new game!"
      puts self.error
      return
    else
      puts "New Game started at:\n#{self.state['viewUrl']}"
    end

    until finished? do

      print "."

      # move somewhere
      url = self.state['playUrl']
      direction = bot.move self.state
      self.state = self.move(url, direction)

    end

  end

  def move url, direction
    process_http_response self.http_client.post(url, {'dir' => direction})
  end

  def create_new_game

    params = {key: self.key}
    if training?
      params[:turns] = self.turns 
      params[:map] = 'm1'
    end

    process_http_response http_client.post("#{self.server}/api/#{self.mode}", params)
    
  end

  def barf
    ap self.state
  end

  def process_http_response response
    if response.status == 200
      success_json response.body
    else
      self.error = response.body
      error_json 
    end
  end

  def success_json stuff
    JSON.parse stuff
  end

  def error_json 
    {'error' => self.error}
  end

  def finished?
    state['game']['finished']
  end

  def arena?
    self.mode == 'arena'
  end

  def training?
    self.mode != 'arena'
  end

end
