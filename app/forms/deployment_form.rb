require 'active_model'

class DeploymentForm
  include ActiveModel::Model

  attr_accessor :deployment_target_id, :resource, :override
  attr_writer :resource_id, :resource_type

  def resource_id
    @resource_id || resource.try(:id)
  end

  def images_attributes=(attrs)
    self.override = Override.new(images: images_from(attrs))
  end

  def save
    Deployment.create(
      resource_type: resource_type,
      resource_id: resource_id,
      deployment_target_id: deployment_target_id,
      override: override
    )
  end

  def images
    resource.service_defs
  end

  def resource_type
    @resource_type ||= resource.class
  end

  private

  def images_from(attrs)
    attrs.each_with_object([]) do |(_,v), memo|
      image = Image.new(name: v['name'])
      image.write_attributes(v.except('id'))
      memo << image
    end
  end

end
