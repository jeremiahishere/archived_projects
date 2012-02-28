require 'erb'
require 'fileutils'
require 'ruby-debug'

class CucumberOffRails
  class Generator
    #require "cucumber_off_rails/generator/options"
    require "cucumber_off_rails/generator/application"

    attr_accessor :options, :remote_site, :project_name, :target_dir

    def initialize(options = {})
      self.options = options
      self.remote_site = options[:remote_site] || "http://www.google.com"
      self.project_name = options[:project_name]
      self.target_dir = options[:directory] || self.project_name || "cucumber_off_rails_project"
    end

    def run
      create_files
    end

    def create_files
      unless File.exists?(target_dir) || File.directory?(target_dir)
        FileUtils.mkdir target_dir
      else
        raise "The directory #{target_dir} already exists, aborting. Maybe move it out of the way before continuing?"
      end

      output_template_in_target "Gemfile"
      output_template_in_target "Rakefile"
      mkdir_in_target "features"
      output_template_in_target File.join("features", "sample.feature")
      mkdir_in_target "features/step_definitions"
      output_template_in_target File.join("features", "step_definitions", "debugging_steps.rb")
      output_template_in_target File.join("features", "step_definitions", "linking_steps.rb")
      output_template_in_target File.join("features", "step_definitions", "login_steps.rb")
      output_template_in_target File.join("features", "step_definitions", "selector_steps.rb")
      output_template_in_target File.join("features", "step_definitions", "validation_steps.rb")
      mkdir_in_target "features/support"
      output_template_in_target File.join("features", "support", "env.rb")
      output_template_in_target File.join("features", "support", "hooks.rb")
      output_template_in_target File.join("features", "support", "paths.rb")
      output_template_in_target File.join("features", "support", "selectors.rb")

    end
    
    def output_template_in_target(source, destination = source)
      final_destination = File.join(target_dir, destination)
      template_result   = render_template(source)

      File.open(final_destination, 'w') {|file| file.write(template_result)}

      $stdout.puts "\tcreate\t#{destination}"
    end

    def render_template(source)
      template_contents = File.read(File.join(template_dir, source))
      template          = ERB.new(template_contents, nil, '<>')

      # squish extraneous whitespace from some of the conditionals
      template.result(binding).gsub(/\n\n\n+/, "\n\n")
    end

    def template_dir
      File.join(File.dirname(__FILE__), 'templates')
    end

    def mkdir_in_target(directory)
      final_destination = File.join(target_dir, directory)

      FileUtils.mkdir final_destination

      $stdout.puts "\tcreate\t#{directory}"
    end
  end
end
