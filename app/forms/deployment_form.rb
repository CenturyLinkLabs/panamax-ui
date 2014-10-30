require 'active_model'

class DeploymentForm
  include ActiveModel::Model

  attr_accessor :deployment_target_id, :template
  attr_writer :template_id

  def template_id
    @template_id || @template.try(:id)
  end

  def save
    Deployment.create(
      template_id: template_id,
      deployment_target_id: deployment_target_id,
    )
  end

end
