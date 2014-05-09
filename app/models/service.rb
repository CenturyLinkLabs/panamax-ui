class Service < BaseResource
  self.prefix = '/apps/:app_id/'

  has_many :ports
  has_many :links

  def category_names
    categories.map(&:name)
  end

  def to_param
    id
  end

  def environment_vars
    environment.attributes.map do |name, value|
      OpenStruct.new({ name: name, value: value, _deleted: false })
    end
  end

  def environment_attributes=(attributes)
    self.environment = attributes.each_with_object({}) do |(index, attribute), hash|
      hash[attribute['name']] = attribute['value'] unless attribute['_deleted'].to_s == '1'
    end
  end

  def ports_attributes=(attributes)
    self.ports = attributes.each_with_object([]) do |(index, port), memo|
      memo << port.except('id') unless port['_deleted'].to_s == '1'
    end
  end

  def links_attributes=(attributes)
    self.links = attributes.each_with_object([]) do |(index, link), memo|
      # exclude link ID for now. May need this later if we decide to
      # expose link ID in API.
      memo << link.except('id') unless link['_deleted'].to_s == '1'
    end
  end

  def self.build_from_response(response)
    attributes = JSON.parse(response)
    self.new(attributes)
  end

end
