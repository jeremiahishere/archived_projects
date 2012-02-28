class CucumberOffRails
  class Generator
    class Options < Hash
      attr_reader :opts, :orig_args

      def initialize(args)
        super()
        @orig_args = args.clone

        require 'optparse'
        @opts = OptionParser.new do |o|
          o.banner = "Usage: #{File.basename($0)} [options]\ne.g. #{File.basename($0)} --set http://www.google.com"

          # need to add a directory option

          o.on('--site [SITE]', 'specify the site to remotely access through capybara' do |site|
            self[:site] = site
          end

        end

        begin
          @opts.parse!(args)
        rescue OptionParser::InvalidOption => e
          self[:invalid_argument] = e.message
        end
      end

      # what this for?
      def merge(other)
        self.class.new(@orig_args + other.orig_args)
      end

    end
  end
end
