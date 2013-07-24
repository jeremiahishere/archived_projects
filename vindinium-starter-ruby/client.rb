require './env'

if ARGV.length < 3
  puts "Usage: bundle exec ruby #{__FILE__} <key> <[training|arena]> <number-of-games|number-of-turns> [server-url]"
  exit -1
else

  CONF = {}
  CONF[:key] = ARGV.shift
  CONF[:mode] = ARGV.shift

  if CONF[:mode] != 'arena'
    CONF[:games] = 1
    CONF[:turns] = ARGV.shift
  else
    CONF[:games] = ARGV.shift
    CONF[:turns] = 300
  end

  CONF[:server] = ARGV.shift if ARGV.length > 0
  CONF[:bot] = RandomBot.new

  game = Vindinium.new(CONF)
  game.start
end


