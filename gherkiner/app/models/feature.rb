class Feature < ActiveRecord::Base
  belongs_to :project

  def self.suggestions_for_project(project, partial_match)
    # attempted to do something clever by making the search not care about Given/When/Then/And when searching for lines
    # gave up. see comments.

    # partial_match.strip!
    # partial_match.gsub!(/^Given|When|Then|And/, '')
    partial_match.strip!
    # puts "------------------------------------------------"
    # puts "\"#{partial_match}\""
    # puts "------------------------------------------------"

    suggestions = {}
    Feature.where(:project_id => project.id).each do |feature|
      feature.contents.split(/\r?\n/).each do |line|
        # line.strip!
        # line.gsub!(/^Given|When|Then|And/, '')
        line.strip!
        next if !line.starts_with?(partial_match) || line.empty? || line.starts_with?("#") || line.starts_with?("@")
        suggestions[line] = 0 unless  suggestions.has_key?(line)
        suggestions[line] += 1
      end
    end

    best_lines = suggestions.sort_by { |k, v| -v }.map { |arr| arr[0] }[0..10]
    best_lines
  end

  def base_file
    File.join(project.path, self.path)
  end

  def read_base_file
    self.contents = File.read(base_file)
  end

  def write_base_file
    File.open(base_file, 'w+') do |file|
      file.write(self.contents) 
    end
  end
end
