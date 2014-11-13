require 'spec_helper'

describe DeploymentForm do

  it { should respond_to :resource_id= }
  it { should respond_to :resource }
  it { should respond_to :resource= }
  it { should respond_to :deployment_target_id }
  it { should respond_to :deployment_target_id= }
  it { should respond_to :override }
  it { should respond_to :override= }

  describe '#images' do
    context 'when resource is a Template' do
      let(:images) { [Image.new] }
      let(:fake_resource) { Template.new(images: images) }

      before do
        subject.resource = fake_resource
      end

      it 'calls Template#images' do
        expect(subject.images).to eq(images)
      end
    end

    context 'when resource is an App' do
      let(:services) { [Service.new] }
      let(:fake_app_resource) { App.new(services: services) }

      before do
        subject.resource = fake_app_resource
      end
      it 'calls App#services' do
        expect(subject.images).to eq(services)
      end
    end
  end

  describe '#resource_id' do
    context 'when a resource id has been set on the object' do
      let(:deployment_form) { described_class.new(resource_id: 7) }

      subject { deployment_form.resource_id }

      it { should eq 7 }
    end

    context 'when a resource is passed in but no resource_id is supplied' do
      let(:fake_resource) { double(:fake_resource, id: 9) }
      let(:deployment_form) { described_class.new(resource: fake_resource) }

      subject { deployment_form.resource_id }

      it { should eq 9 }
    end

    context 'when neither resource or resource_id are supplied' do
      let(:deployment_form) { described_class.new }

      subject { deployment_form.resource_id }

      it { should be_nil }
    end
  end

  describe '#images_attributes=' do
    let(:fake_images_attrs) do
      {"0"=>
       {"name"=>"WP",
        "environment_attributes"=>
       {"0"=>{"variable"=>"DB_PASSWORD", "value"=>"pass@word01", "id"=>""}},
       "id"=>"29"},
       "1"=>
       {"name"=>"DB",
        "environment_attributes"=>
       {"0"=>
        {"variable"=>"MYSQL_ROOT_PASSWORD", "value"=>"pass@word01", "id"=>""}},
       "id"=>"30"}}
    end

    before do
      subject.images_attributes = fake_images_attrs
    end

    it 'creates an override object from the supplied attributes' do
      expect(subject.override).to be_a Override
    end

    it 'properly maps images to the override object' do
      first_image = subject.override.images.first
      expect(first_image.name).to eq 'WP'
      expect(first_image.attributes.keys).to match_array ['name', 'environment']
      expect(first_image.environment).to eq [{"variable"=>"DB_PASSWORD", "value"=>"pass@word01"}]
    end
  end

  describe '#save' do
    let(:deployment_form) do
      described_class.new(
        resource: double(:resource, id: 1, class: 'Template'),
        deployment_target_id: 2
      )
    end

    subject { deployment_form.save }

    it 'creates the deployment' do
      expect(Deployment).to receive(:create).with(
        resource_id: 1,
        resource_type: 'Template',
        deployment_target_id: 2,
        override: nil
      )
      subject
    end
  end

end
