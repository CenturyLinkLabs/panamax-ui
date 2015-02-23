require 'spec_helper'

describe Image do
  it { should respond_to :environment }

  describe '#id' do
    it { should respond_to :id }
  end

  describe '#category' do
    it { should respond_to :category }
  end

  describe '#name' do
    it { should respond_to :name }
  end

  describe '#source' do
    it { should respond_to :source }
  end

  describe '#description' do
    it { should respond_to :description }
  end

  describe '#type' do
    it { should respond_to :type }
  end

  describe '#expose' do
    it { should respond_to :expose }
  end

  describe '#volumes' do
    it { should respond_to :volumes }
  end

  describe '#command' do
    it { should respond_to :command }
  end

  describe '#environment_attributes=' do
    it 'assigns environment to the values of the passed in attrs' do
      var_1 = { 'variable' => 'booh', 'value' => 'yah' }
      var_2 = { 'variable' => 'GIT_REPO', 'value' => 'bla.git' }
      subject.environment_attributes = {
        '0' => var_1.merge({'id' => 'excluded'}),
        '1' => var_2
      }
      expect(subject.environment).to match_array [var_1, var_2]
    end
  end

  describe '#deployment_attributes=' do
    let(:some_attrs_hash) { { 'some' => 'attrs' } }

    it 'sets the deployment attrs to what was passed in' do
      subject.deployment_attributes= some_attrs_hash
      expect(subject.attributes['deployment']).to eq some_attrs_hash
    end
  end

  describe '#deployment' do
    it 'returns a representation of default deployment settings' do
      expect(subject.deployment.count).to eq 1
    end
  end

  describe '#docker_index_url' do
    before do
      subject.source = 'ctl/booyah:latest'
    end

    it 'returns the url' do
      expect(subject.docker_index_url).to eq 'https://registry.hub.docker.com/u/ctl/booyah'
    end
  end

  describe '#base_image_name' do
    let(:docker_image_name) { double(:docker_image_name, base_image: 'fooyah') }

    before do
      allow(DockerImageName).to receive(:parse).with(subject.source).and_return(docker_image_name)
    end

    it 'delegates to the Docker helper' do
      expect(subject.base_image_name).to eq 'fooyah'
    end
  end

  describe '#icon' do
    it 'returns the icon source for the type when set' do
      subject.type = 'wordpress'
      expect(subject.icon).to eq '/assets/type_icons/wordpress.svg'
    end

    it 'returns the default icon when type is not set' do
      expect(subject.icon).to eq '/assets/type_icons/default.svg'
    end
  end

end
