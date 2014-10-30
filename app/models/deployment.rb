class Deployment < BaseResource
  self.prefix = '/deployment_targets/:deployment_target_id/'

  schema do
    integer :id
    integer :template_id
  end

  def to_param
    self.id
  end
end
