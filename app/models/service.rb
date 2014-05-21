class Service < BaseResource

  DOCKER_INDEX_BASE_URL = 'https://index.docker.io/'

  self.prefix = '/apps/:app_id/'

  has_many :ports
  has_many :links

  DEFAULT_ICON_URL = 'http://panamax.ca.tier3.io/service_icons/icon_service_docker_grey.png'

  def category_names
    categories.map(&:name)
  end

  def to_param
    id
  end

  def status
    case sub_state
    when 'running'
      :running
    when 'dead', 'start-pre', 'auto-restart', 'stop-post'
      :loading
    else
      :stopped
    end
  end

  def icon
    self.attributes[:icon].blank? ? DEFAULT_ICON_URL : self.attributes[:icon]
  end

  def environment_vars
    environment.attributes.map do |name, value|
      OpenStruct.new({ name: name, value: value, _deleted: false })
    end
  end

  def running?
    self.sub_state == 'running'
  end

  def environment_attributes=(attributes)
    self.environment = attributes.each_with_object({}) do |(index, attribute), hash|
      hash[attribute['name']] = attribute['value'] unless attribute['_deleted'].to_s == '1'
    end
  end

  def ports_attributes=(attributes)
    self.ports = attributes.each_with_object([]) do |(index, port), memo|
      memo << port.except('id', '_deleted') unless port['_deleted'].to_s == '1'
    end
  end

  def links_attributes=(attributes)
    self.links = attributes.each_with_object([]) do |(index, link), memo|
      # exclude link ID for now. May need this later if we decide to
      # expose link ID in API.
      memo << link.except('id', '_deleted') unless link['_deleted'].to_s == '1'
    end
  end

  def service_source_name
    self.from.gsub(/:+\S*/, '')
  end

  def category_priority
    categories.min_by { |category| category.id }.id
  end

  def docker_index_url
    path_part = "u/#{self.service_source_name}"
    "#{DOCKER_INDEX_BASE_URL}#{path_part}"
  end

  def self.build_from_response(response)
    attributes = JSON.parse(response)
    self.new(attributes)
  end

end
