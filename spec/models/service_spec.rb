require 'spec_helper'

describe Service do
  let(:attributes) do
    {
      'name' => 'Wordpress',
      'id' => 77,
      'categories' => [{'name' => 'foo', 'id' => 20}, {'name' => 'baz', 'id' => 10}],
      'ports' => [
        {'host_port' => 8080, 'container_port' => 80},
        {'host_port' => 7000, 'container_port' => 77}
      ],
      'environment' => {
        'DB_PASS' => 'pazz',
        'WP_PASS' => 'abc123'
      },
      'links' => [
        {'service_name' => 'DB'},
        {'service_name' => 'Wordpress'}
      ]
    }
  end

  it_behaves_like 'an active resource model'

  let(:fake_json_response) { attributes.to_json }

  describe '#status' do
    it 'is :running when sub state is running' do
      subject.sub_state = 'running'
      expect(subject.status).to eq :running
    end

    it 'is :loading when sub state is dead' do
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
      expect(subject.status).to eq :stopped
    end

    it 'is :stopped when sub state is something else' do
      subject.sub_state = 'somethingelse'
      expect(subject.status).to eq :stopped
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
      expect(result.categories.map(&:name)).to match_array(['foo', 'baz'])
    end

    it 'instantiates a PortMapping for each nested port' do
      result = described_class.build_from_response(fake_json_response)
      expect(result.ports.map(&:host_port)).to match_array([8080, 7000])
      expect(result.ports.map(&:container_port)).to match_array([80, 77])
    end

    it 'instantiates an environment variable for each nested variable' do
      result = described_class.build_from_response(fake_json_response)
      expect(result.environment.attributes).to eq attributes['environment']
    end

    it 'instantiates a link for each link' do
      result = described_class.build_from_response(fake_json_response)
      expect(result.links.map(&:service_name)).to match_array(['DB', 'Wordpress'])
    end
  end

  describe '#category_names' do
    it 'returns an array containing the names of its categories' do
      result = described_class.build_from_response(fake_json_response)
      expect(result.category_names).to match_array(['foo', 'baz'])
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
        subject.icon = 'http://foo.com/bar.png'
        expect(subject.icon).to eq 'http://foo.com/bar.png'
      end
    end

    context 'no icon is specified' do
      it 'returns the URL of the default icon' do
        subject.icon = ''
        expect(subject.icon).to eq 'http://panamax.ca.tier3.io/service_icons/icon_service_docker_grey.png'
      end
    end

  end

  describe '#links_attributes=' do
    let(:attributes) do
      {
        '0' => { 'service_id' => 99, 'alias' => 'foo', '_deleted' => false },
        '1' => { 'service_id' => nil, 'alias' => 'bar', '_deleted' => 1 }
      }
    end

    it 'assigns to links when not deleted' do
      subject.links_attributes = attributes
      expect(subject.links).to include attributes['0'].except('_deleted')
    end

    it 'does not assign to links when _deleted is 1' do
      subject.links_attributes = attributes
      expect(subject.links).to_not include({ 'service_id' => nil, 'alias' => 'bar', '_deleted' => 1 })
    end

    it 'excludes the id' do
      subject.links_attributes = attributes
      expect(subject.links.last.keys).to_not include 'id'
    end

    it 'excludes the _deleted flag' do
      subject.links_attributes = attributes
      expect(subject.links.last.keys).to_not include '_deleted'
    end
  end

  describe '#ports_attributes=' do
    let(:attributes) do
      {
        '0' => { 'host_port' => 9090, 'container_port' => 90, '_deleted' => false },
        '1' => { 'host_port' => 8080, 'container_port' => 70, '_deleted' => 1 },
        '2' => { 'host_port' => 6060, 'container_port' => 60, 'id' => nil, '_deleted' => false }
      }
    end

    it 'assigns to ports when container port is non nil' do
      subject.ports_attributes = attributes
      expect(subject.ports).to include attributes['0'].except('_deleted')
    end

    it 'does not assign to links when _deleted is 1' do
      subject.ports_attributes = attributes
      expect(subject.ports).to_not include({ 'host_port' => 9090, 'container_port' => 70 })
    end

    it 'excludes the id' do
      subject.ports_attributes = attributes
      expect(subject.ports.last.keys).to_not include 'id'
    end

    it 'excludes the _deleted flag' do
      subject.ports_attributes = attributes
      expect(subject.ports.last.keys).to_not include '_deleted'
    end
  end

  describe '#environment_vars' do
    subject { described_class.new(environment: { boo: 'yah' }) }

    it 'returns a struct for the form to consume' do
      expected = OpenStruct.new(name: 'boo', value: 'yah', _deleted: false)
      expect(subject.environment_vars).to eq [expected]
    end
  end

  describe '#environment_attributes=' do
    let(:attributes) do
      {
        '0' => { 'name' => 'PASSWORD', 'value' => 'abc123' }
      }
    end

    it 'assigns the attributes to environment' do
      subject.environment_attributes = attributes
      expect(subject.environment).to eq({ 'PASSWORD' => 'abc123' })
    end
  end

  describe '#service_source_name' do
    it 'returns the base image name without any tag information' do
      subject.from = 'supercool/repository:foobar'
      expect(subject.service_source_name).to eq 'supercool/repository'
    end
  end

  describe '#docker_index_url' do
    it 'composes a docker index URL' do
      subject.from = 'supercool/repository'
      expect(subject.docker_index_url).to eq 'https://index.docker.io/u/supercool/repository'
    end
  end

  describe '#category_priority' do
    it 'returns the category with the lowest id' do
      result = described_class.build_from_response(fake_json_response)
      expect(result.category_priority).to eq 10
    end
  end
end
