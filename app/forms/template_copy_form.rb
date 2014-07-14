require 'active_model'

class TemplateCopyForm
  include ActiveModel::Model

  attr_writer :original_template

  def template_id
    @original_template.id
  end

  def images
    @original_template.images
  end

  def images_attributes=(attrs)
    @images_attributes = attrs
  end

  def create_new_template
    new_template = Template.new(@original_template.attributes)
    new_template.images.each do |img|
      img.environment_attributes = env_attrs_for(img)
      img.id = nil
    end
    new_template.tap(&:save)
  end

  private

  def env_attrs_for(img)
    @images_attributes.values.detect do |img_attrs|
      img_attrs['id'] == img.id.to_s
    end['environment_attributes']
  end
end
