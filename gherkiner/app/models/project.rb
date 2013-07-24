class Project < ActiveRecord::Base
  has_many :features

  def find_features
    found_feature_paths = []
    features = File.join(self.path, '**', '*.feature')
    Dir.glob(features) do |file|
      contents = File.read(file)
      file.gsub!(self.path, '')

      if Feature.where(:project_id => self.id, :path => file).any? 
        feature = Feature.where(:project_id => self.id, :path => file).first
      else
        feature = Feature.create!(:project_id => self.id, :path => file)
      end

      feature.read_base_file
      feature.save!

      found_feature_paths << file
    end
    Feature.where.not(:path => found_feature_paths).map(&:destroy)
  end
end
