class Service < BaseResource
  self.prefix = '/apps/:app_id/'

  def category_names
    categories.map(&:name)
  end

  def to_param
    id
  end

  def self.build_from_response(response)
    attributes = JSON.parse(response)
    self.new(attributes)
  end

end
