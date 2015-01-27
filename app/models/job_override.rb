class JobOverride < BaseResource
  has_many :environment

  def environment_attributes=(attrs)
    self.environment = attrs.values.map do |v|
      Environment.new(v)
    end
  end
end
