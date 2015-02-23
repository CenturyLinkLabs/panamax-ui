require 'spec_helper'

describe Service do
  let(:attributes) do
    {
      'name' => 'Wordpress',
      'id' => 77,
      'categories' => [{ 'name' => 'foo', 'id' => 20 }, { 'name' => 'baz', 'id' => 10 }],
      'ports' => [
        { 'host_port' => 8080, 'container_port' => 80, 'proto' => 'TCP' },
        { 'host_port' => 7000, 'container_port' => 77, 'proto' => 'UDP' }
      ],
      'environment' => [
        { 'variable' => 'DB_PASS', 'value' => 'pazz' },
        { 'variable' => 'WP_PASS', 'value' => 'abc123' }
      ],
      'links' => [
        { 'service_name' => 'DB', 'service_id' => 1 },
        { 'service_name' => 'Wordpress', 'service_id' => 1 }
      ],
      'volumes_from' => [
        { 'service_name' => 'name1', 'service_id' => 1 },
        { 'service_name' => 'name2', 'service_id' => 2 }
      ],
      'volumes' => [
        { 'container_path' => 'foo', 'host_path' => 'host' },
        { 'container_path' => 'bar', 'host_path' => '' }
      ],
      'app' => {
        'id' => 1
      }
    }
  end

  let(:fake_json_response) { attributes.to_json }

  it_behaves_like 'an active resource model'

  it { should respond_to :id }
  it { should respond_to :name }
  it { should respond_to :description }
  it { should respond_to :from }
  it { should respond_to :load_state }
  it { should respond_to :active_state }
  it { should respond_to :sub_state }
  it { should respond_to :icon }

  it { should respond_to :ports }
  it { should respond_to :links }
  it { should respond_to :environment }
  it { should respond_to :docker_status }
  it { should respond_to :command }

  describe '#has_empty_env_values?' do
    it 'returns true if a value is blank' do
      subject.environment = [
        Environment.new('variable' => 'PORT', 'value' => '80'),
        Environment.new('variable' => 'OPTIONAL', 'value' => '')
      ]
      expect(subject.has_empty_env_values?).to be_truthy
    end

    it 'returns true if a value is missing' do
      subject.environment = [
        Environment.new('variable' => 'PORT', 'value' => '80'),
        Environment.new('variable' => 'OPTIONAL')
      ]
      expect(subject.has_empty_env_values?).to be_truthy
    end

    it 'returns false if there are no env vars' do
      subject.environment = []
      expect(subject.has_empty_env_values?).to be_falsey
    end

    it 'returns false if there are no empty valued env vars' do
      subject.environment = [
        Environment.new('variable' => 'PORT', 'value' => '80'),
        Environment.new('variable' => 'OPTIONAL', 'value' => 'present')
      ]
      expect(subject.has_empty_env_values?).to be_falsey
    end
  end

  describe '#status' do
    it 'is :running when sub state is running' do
      subject.sub_state = 'running'
      expect(subject.status).to eq :running
    end

    it 'is :stopped when sub state is failed and loading state is not-found' do
      subject.sub_state = 'failed'
      subject.load_state = 'not-found'
      expect(subject.status).to eq :stopped
    end

    it 'is :stopped when sub state is dead but active state is active' do
      subject.sub_state = 'dead'
      subject.active_state = 'active'
      expect(subject.status).to eq :stopped
    end

    it 'is :stopped when sub state is dead and load state is not-found' do
      subject.sub_state = 'dead'
      subject.load_state = 'not-found'
      expect(subject.status).to eq :stopped
    end

    it 'is :loading when states are loaded, inactive, and dead' do
      subject.load_state = 'loaded'
      subject.active_state = 'inactive'
      subject.sub_state = 'dead'
      expect(subject.status).to eq :loading
    end

    it 'is :loading when sub state is start-pre' do
      subject.sub_state = 'start-pre'
      expect(subject.status).to eq :loading
    end

    it 'is :loading when sub state is auto-restart' do
      subject.sub_state = 'auto-restart'
      expect(subject.status).to eq :loading
    end

    it 'is :loading when sub state is stop-post' do
      subject.sub_state = 'stop-post'
      expect(subject.status).to eq :loading
    end

    it 'is :stopped when sub state is nil' do
      subject.sub_state = nil
      expect(subject.status).to eq :loading
    end

    it 'is :loading when sub state is something else' do
      subject.sub_state = 'somethingelse'
      expect(subject.status).to eq :loading
    end

  end

  describe '#running?' do
    it 'is true when sub state is running' do
      subject.sub_state = 'running'
      expect(subject.running?).to be_truthy
    end

    it 'is false when sub state is something else' do
      subject.sub_state = 'somethingelse'
      expect(subject.running?).to be_falsey
    end

  end

  describe '.build_from_response' do
    it 'instantiates itself with the parsed json attributes' do
      result = described_class.build_from_response(fake_json_response)
      expect(result).to be_a Service
      expect(result.name).to eq 'Wordpress'
      expect(result.id).to eq 77
    end

    it 'instantiates a ServiceCategory for each nested category' do
      result = described_class.build_from_response(fake_json_response)
      expect(result.categories.map(&:name)).to match_array(%w(foo baz))
    end

    it 'instantiates a PortMapping for each nested port' do
      result = described_class.build_from_response(fake_json_response)
      expect(result.ports.map(&:host_port)).to match_array([8080, 7000])
      expect(result.ports.map(&:container_port)).to match_array([80, 77])
    end

    it 'instantiates an environment variable for each nested variable' do
      result = described_class.build_from_response(fake_json_response)
      expect(result.environment).to match_array((attributes['environment'].map { |attrs| Environment.new(attrs) }))
    end

    it 'instantiates a link for each link' do
      result = described_class.build_from_response(fake_json_response)
      expect(result.links.map(&:service_name)).to match_array(%w(DB Wordpress))
    end

    it 'instantiates a volumes_from for each link' do
      result = described_class.build_from_response(fake_json_response)
      expect(result.volumes_from.map(&:service_name)).to match_array(%w(name1 name2))
    end
  end

  describe '#category_names' do
    it 'returns an array containing the names of its categories' do
      result = described_class.build_from_response(fake_json_response)
      expect(result.category_names).to match_array(%w(foo baz))
    end
  end

  describe '#to_param' do
    subject { described_class.new('id' => 77) }

    it 'returns the id' do
      expect(subject.to_param).to eq 77
    end
  end

  describe '#icon' do
    context 'an icon was provided by the image' do
      it 'returns the URL of the image icon' do
        subject.type = 'wordpress'
        expect(subject.icon).to eq '/assets/type_icons/wordpress.svg'
      end
    end

    context 'no icon is specified' do
      it 'returns the URL of the default icon' do
        subject.type = nil
        expect(subject.icon).to eq '/assets/type_icons/default.svg'
      end
    end

  end

  describe '#links_attributes=' do
    let(:attributes) do
      {
        '0' => { 'service_id' => 99, 'alias' => 'foo', '_deleted' => false, 'id' => 1 },
        '1' => { 'service_id' => 78, 'alias' => 'bar', '_deleted' => 1, 'id' => 2 },
        '2' => { 'service_id' => nil, 'alias' => 'bar', '_deleted' => false, 'id' => 2 }
      }
    end

    it 'assigns to links when not deleted' do
      subject.links_attributes = attributes
      expect(subject.links).to eq [Link.new(attributes['0'].except('id'))]
    end

    it 'does not assign to links when service_id is blank' do
      subject.links_attributes = attributes
      expect(subject.links.map(&:alias)).to_not include 'bar'
    end

    it 'does not assign to links when _deleted is 1' do
      subject.links_attributes = attributes
      expect(subject.links.map(&:alias)).to_not include 'bar'
    end

    it 'excludes the id' do
      subject.links_attributes = attributes
      expect(subject.links.last.attributes.keys).to_not include 'id'
    end
  end

  describe '#volumes_attributes=' do
    let(:attributes) do
      {
        '0' => { 'host_path' => '/bla/bla', 'container_path' => '/also/bla', '_deleted' => false, 'id' => nil },
        '1' => { 'host_path' => 'path/deleted', 'container_path' => 'path/deleted', '_deleted' => 1 }
      }
    end

    it 'only assigns values that are not deleted' do
      subject.volumes_attributes = attributes
      expect(subject.volumes.length).to eq 1
      expect(subject.volumes.first).to eq Volume.new(attributes['0'])
    end

    it 'excludes the id' do
      subject.volumes_attributes = attributes
      expect(subject.volumes.last.attributes.keys).to eq ['host_path', 'container_path', '_deleted']
    end
  end

  describe '#volumes_from_attributes=' do
    let(:attributes) do
      {
        '0' => { 'service_name' => 'name1', 'service_id' => 1,  '_deleted' => false },
        '1' => { 'service_name' => 'name2', 'service_id' => 2, '_deleted' => 1 }
      }
    end

    it 'assigns to volumes_from when container_path is non nil' do
      subject.volumes_from_attributes = attributes
      expect(subject.volumes_from).to include VolumesFrom.new(attributes['0'])
    end

    it 'does not assign to volumes_from when _deleted is 1' do
      subject.volumes_from_attributes = attributes
      expect(subject.volumes_from.map(&:service_name)).to_not include 'path2'
    end
  end

  describe '#ports_attributes=' do
    let(:attributes) do
      {
        '0' => { 'host_port' => 9090, 'container_port' => 90, 'proto' => 'TCP', '_deleted' => false },
        '1' => { 'host_port' => 8080, 'container_port' => 70, 'proto' => 'TCP', '_deleted' => 1 },
        '2' => { 'host_port' => nil, 'container_port' => 60, 'proto' => 'TCP', 'id' => nil, '_deleted' => false }
      }
    end

    it 'assigns to ports when container port is non nil' do
      subject.ports_attributes = attributes
      expect(subject.ports).to include Port.new(attributes['0'])
    end

    it 'does not assign to ports when _deleted is 1' do
      subject.ports_attributes = attributes
      expect(subject.ports.map(&:host_port)).to_not include '8080'
    end

    it 'excludes the id' do
      subject.ports_attributes = attributes
      expect(subject.ports.last.attributes.keys).to_not include 'id'
    end

    it 'excludes the host_port if the value is empty' do
      subject.ports_attributes = attributes
      expect(subject.ports.last.attributes.keys).to_not include 'host_port'
    end
  end

  describe '#exposed_ports_attributes=' do
    let(:attributes) do
      {
        '0' => { 'port_number' => '111', '_deleted' => false },
        '1' => { 'port_number' => '222', '_deleted' => 1 },
        '2' => { 'port_number' => '', '_deleted' => false }
      }
    end

    before do
      subject.exposed_ports_attributes = attributes
    end

    it 'assigns exposed ports when the port_number is valid' do
      expect(subject.exposed_ports.size).to be 1
      expect(subject.exposed_ports.first['port_number']).to eq '111'
    end
  end

  describe '#environment_attributes=' do
    let(:attributes) do
      {
        '0' => { 'variable' => 'WP_PASS', 'value' => 'abc123', '_deleted' => false },
        '1' => { 'variable' => 'SPECIAL', 'value' => 'sauce', '_deleted' => 1 },
        '2' => { 'variable' => 'SECRET', 'value' => 'handshake', 'id' => nil, '_deleted' => false }
      }
    end

    before do
      subject.environment_attributes = attributes
    end

    it 'assigns to environments when variable and value are non nil' do
      expect(subject.environment).to include Environment.new(attributes['0'])
    end

    it 'does not assign to environment when _deleted is 1' do
      variables = subject.environment.map(&:variable)
      expect(variables.length).to eq 2
      expect(variables).to_not include 'SPECIAL'
    end

    it 'excludes the id' do
      expect(subject.environment.last.attributes.keys).to_not include 'id'
    end
  end

  describe '#default_ports' do
    it 'assigns the ports to an array' do
      subject.default_exposed_ports = ['3000/tcp', '8888/tcp']
      expect(subject.default_ports).to be_an(Array)
      expect(subject.default_ports.length).to eq(2)
    end

    it 'includes both port_number and protocol' do
      subject.default_exposed_ports = ['3000/tcp', '8888/tcp']
      expect(subject.default_ports.first['port_number']).to eq '3000'
      expect(subject.default_ports.first['proto']).to eq 'tcp'

    end

  end

  describe '#base_image_name' do
    let(:docker_image_name) { double(:docker_image_name, base_image: 'fooyah') }

    before do
      allow(DockerImageName).to receive(:parse).with(subject.from).and_return(docker_image_name)
    end

    it 'delegates to the Docker helper' do
      expect(subject.base_image_name).to eq 'fooyah'
    end
  end

  describe '#image_tag_name' do
    let(:docker_image_name) { double(:docker_image_name, tag: 'latest') }

    before do
      allow(DockerImageName).to receive(:parse).with(subject.from).and_return(docker_image_name)
    end

    it 'delegates to the Docker helper' do
      expect(subject.image_tag_name).to eq 'latest'
    end
  end

  describe '#docker_search_url' do
    it 'composes a docker search URL' do
      subject.from = 'supercool/repository'
      expect(subject.docker_search_url).to eq "#{DOCKER_INDEX_BASE_URL}search?q=supercool/repository"
    end
  end

  describe '#category_priority' do
    it 'returns the category with the lowest id' do
      result = described_class.build_from_response(fake_json_response)
      expect(result.category_priority).to eq 10
    end
  end

  describe '#select_data_volumes' do
    it 'returns volumes with only container path defined' do
      result = described_class.build_from_response(fake_json_response)
      expect(result.select_data_volumes).to match_array [Volume.new({ 'container_path' => 'bar', 'host_path' => '' })]
    end
  end

  describe '#hydrate_linked_services!' do
    let(:fake_service) { double(:fake_service, id: 3) }
    before do
      allow(Service).to receive(:find).and_return(fake_service)
    end
    it 'returns complete service model as linked_to_service on each link' do
      result = described_class.build_from_response(fake_json_response)
      result.hydrate_linked_services!
      result.links.each do |link|
        expect(link.linked_to_service).to be fake_service
      end
    end
  end

  describe '#as_json' do
    it 'returns the status attribute' do
      expect(subject.as_json).to include('status' => :loading)
    end
  end
end
