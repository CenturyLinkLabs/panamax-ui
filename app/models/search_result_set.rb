class SearchResultSet < BaseViewModel

  attr_reader :query, :remote_images, :local_images, :templates

  def initialize(attributes)
    @query = attributes['q']
    @remote_images = wrap_images(attributes['remote_images'], Image.locations[:remote])
    @local_images = wrap_images(attributes['local_images'], Image.locations[:local])
    @templates = wrap_templates(attributes['templates'])
  end

  def self.build_from_response(response)
    attributes = JSON.parse(response)
    self.new(attributes)
  end

  private

  def wrap_templates(templates)
    (templates || []).map do |template_attributes|
      Template.new(template_attributes)
    end
  end

  def wrap_images(images, label)
    (images || []).map do |image_attributes|
      Image.new( image_attributes.merge('location' => label) )
    end
  end

end
