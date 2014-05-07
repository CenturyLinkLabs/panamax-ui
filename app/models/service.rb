class Service < BaseResource
  self.prefix = '/apps/:app_id/'

  def category_names
    categories.map(&:name)
  end

  def to_param
    id
  end

  def links_attributes=(attributes)
    self.links = attributes.each_with_object([]) do |(index, link), memo|
      # exclude link ID for now. May need this later if we decide to
      # expose link ID in API.
      memo << link.except('id') if link['service_id'].present?
    end
  end

  def self.build_from_response(response)
    attributes = JSON.parse(response)
    self.new(attributes)
  end

end
