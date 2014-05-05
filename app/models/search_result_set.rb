class SearchResultSet < BaseViewModel

  attr_reader :query, :remote_images, :local_images, :templates

  def initialize(attributes)
    super
    @query = attributes['q']
  end

  def self.build_from_response(response)
    attributes = JSON.parse(response)
    build_with_sub_resources(attributes)
  end

  private

  def self.build_with_sub_resources(attributes)
    attributes['remote_images'].each do |image|
      image['location'] = Image.locations[:remote]
    end
    attributes['remote_images'] = Image.instantiate_collection(attributes['remote_images'])
    attributes['local_images'].each do |image|
      image['location'] = Image.locations[:local]
    end
    attributes['local_images'] = Image.instantiate_collection(attributes['local_images'])
    attributes['templates'] = Template.instantiate_collection(attributes['templates'])
    self.new(attributes)
  end
end
