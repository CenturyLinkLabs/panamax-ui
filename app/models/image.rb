class Image < BaseResource
  has_many :environment

  schema do
    integer :id
    string :category
    string :name
    string :source
    string :description
    string :type
    string :expose
    string :volumes
    string :command
  end

  def required_fields_missing?
    environment.any? do |env|
      env.required.present? && env.value.blank?
    end
  end

  def environment_attributes=(attrs)
    self.environment = attrs.values
  end
end
