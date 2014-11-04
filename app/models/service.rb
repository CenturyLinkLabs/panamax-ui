class Service < BaseResource
  include ApplicationHelper

  self.prefix = '/apps/:app_id/'

  has_many :ports
  has_many :links
  has_many :environment
  has_many :volumes
  has_many :volumes_from
  has_one :docker_status

  schema do
    integer :id
    string :name
    string :description
    string :from
    string :load_state
    string :active_state
    string :sub_state
    string :type
    string :command
  end

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
    when 'failed' # one case where it's not loading
      load_state == 'not-found' ? :stopped : :loading
    when 'dead' # should always be stopped except for one case
      load_state == 'loaded' && active_state == 'inactive' ? :loading : :stopped
    else
      :loading
    end
  end

  def has_empty_env_values?
    environment.any? do |env|
      env.value.blank?
    end
  end

  def icon
    type.blank? ? icon_source_for('default') : icon_source_for(type)
  end

  def running?
    self.sub_state == 'running'
  end

  def environment_attributes=(attributes)
    self.environment = attributes.each_with_object([]) do |(_, env), memo|
      memo << Environment.new(env.except('id')) unless env['_deleted'].to_s == '1'
    end
  end

  def ports_attributes=(attributes)
    self.ports = attributes.each_with_object([]) do |(_, port), memo|
      unless port['_deleted'].to_s == '1'
        excludes = ['id']
        excludes << 'host_port' if port['host_port'].blank?
        memo << Port.new(port.except(*excludes))
      end
    end
  end

  def volumes_attributes=(attributes)
    self.volumes = attributes.each_with_object([]) do |(_, volume), memo|
      memo << Volume.new(volume.except('id')) unless volume['_deleted'].to_s == '1'
    end
  end

  def volumes_from_attributes=(attributes)
    self.volumes_from = attributes.each_with_object([]) do |(_, volume_from), memo|
      memo << VolumesFrom.new(volume_from.except('id')) unless volume_from['_deleted'].to_s == '1'
    end
  end

  def links_attributes=(attributes)
    self.links = attributes.each_with_object([]) do |(_, link), memo|
      # exclude link ID for now. May need this later if we decide to
      # expose link ID in API.
      memo << Link.new(link.except('id')) unless link['_deleted'].to_s == '1' || link['service_id'].blank?
    end
  end

  def exposed_ports_attributes=(attributes)
    self.expose = attributes.each_with_object([]) do |(_, exposed_port), memo|
      exposed_port['_deleted'] = 1 if exposed_port['port_number'].blank?
      memo << exposed_port['port_number'] unless exposed_port['_deleted'].to_s == '1'
    end
  end

  def base_image_name
    docker_image_name.base_image
  end

  def image_tag_name
    docker_image_name.tag
  end

  def category_priority
    categories.min_by { |category| category.id }.id
  end

  def docker_index_url
    path_part = "u/#{self.base_image_name}"
    "#{DOCKER_INDEX_BASE_URL}#{path_part}"
  end

  def as_json(options={})
    super.merge('status' => status)
  end

  def exposed_ports
    self.expose.each_with_object([]) do |port, memo|
      memo << OpenStruct.new({port_number: port})
    end
  end

  def default_ports
    self.default_exposed_ports.each_with_object([]) do |port, memo|
      port_number, protocol = port.split('/')
      memo << OpenStruct.new({port_number: port_number, proto: protocol})
    end
  end

  def select_data_volumes
    self.volumes.select { |volume| volume.host_path.empty? }
  end

  def self.build_from_response(response)
    attributes = JSON.parse(response)
    self.new(attributes)
  end

  def hydrate_linked_services!
    self.links.each do |link|
      link.linked_to_service = Service.find(link.service_id, params: { app_id: self.app.id })
    end
  end

  private

  def docker_image_name
    @docker_image_name ||= DockerImageName.parse(from)
  end
end
