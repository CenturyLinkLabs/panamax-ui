require 'spec_helper'

describe DeploymentForm do

  it { should respond_to :template_id= }
  it { should respond_to :template }
  it { should respond_to :template= }
  it { should respond_to :deployment_target_id }
  it { should respond_to :deployment_target_id= }
  it { should respond_to :override }
  it { should respond_to :override= }

  describe '#images' do
    let(:fake_template) { double(:fake_template) }

    before do
      subject.template = fake_template
    end

    it 'delegates to the template' do
      expect(fake_template).to receive(:images)
      subject.images
    end
  end

  describe '#template_id' do
    context 'when a template id has been set on the object' do
      let(:deployment_form) { described_class.new(template_id: 7) }

      subject { deployment_form.template_id }

      it { should eq 7 }
    end

    context 'when a template is passed in but no template_id is supplied' do
      let(:fake_template) { double(:fake_template, id: 9) }
      let(:deployment_form) { described_class.new(template: fake_template ) }

      subject { deployment_form.template_id }

      it { should eq 9 }
    end

    context 'when neither template or template_id are supplied' do
      let(:deployment_form) { described_class.new }

      subject { deployment_form.template_id }

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
        template_id: 1,
        deployment_target_id: 2
      )
    end

    subject { deployment_form.save }

    it 'creates the deployment' do
      expect(Deployment).to receive(:create).with(
        template_id: 1,
        deployment_target_id: 2,
        override: nil
      )
      subject
    end
  end

end
