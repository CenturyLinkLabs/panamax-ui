class Job < BaseResource
  has_one :override, class_name: 'JobOverride'

  schema do
    integer :template_id
  end

  def self.new_from_template(template)
    self.new(
      override: { environment: template.environment },
      template_id: template.id
    )
  end

  def self.nested_create(attrs)
    instance = self.new(template_id: attrs[:template_id])
    instance.write_attributes(attrs)
    instance.save
  end

  def override_attributes=(attrs)
    override = JobOverride.new
    override.write_attributes(attrs)
    self.override = override
  end
end
