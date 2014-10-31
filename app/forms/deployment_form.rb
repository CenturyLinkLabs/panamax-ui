require 'active_model'

class DeploymentForm
  include ActiveModel::Model

  attr_accessor :deployment_target_id, :template, :override
  attr_writer :template_id

  delegate :images, to: :template

  def template_id
    @template_id || @template.try(:id)
  end

  def images_attributes=(attrs)
    self.override = Override.new(images: images_from(attrs))
  end

  def save
    Deployment.create(
      template_id: template_id,
      deployment_target_id: deployment_target_id,
      override: override
    )
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
