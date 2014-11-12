class Deployment < BaseResource
  self.prefix = '/deployment_targets/:deployment_target_id/'

  has_one :override

  schema do
    integer :id
    integer :template_id
    string :name
  end

  def to_param
    self.id
  end

  def display_name
    self.name || 'Unnamed Deployment'
  end
end
