require 'shellwords'

class CucumberOffRails
  class Generator
    class Application
      class << self
        include Shellwords
        def run!(*arguments)
          # cant get options generator included for some reason
          #options = build_options(arguments)
          options = {}

          if options[:invalid_argument]
            $stderr.puts options[:invalid_argument]
            options[:show_help] = true
          end

          if options[:show_help]
            $stderr.puts options.opts
            return 1
          end

          generator = CucumberOffRails::Generator.new(options)
          generator.run
          return 0
        end

        def build_options(arguments)
          env_opts_string = ENV['CUCUMBER_OFF_RAILS_OPTS'] || ""
          env_opts        = CucumberOffRails::Generator::Options.new(shellwords(env_opts_string))
          argument_opts   = CucumberOffRails::Generator::Options.new(arguments)

          env_opts.merge(argument_opts)
        end
      end
    end
  end
end
