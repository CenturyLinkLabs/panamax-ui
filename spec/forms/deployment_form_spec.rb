require 'spec_helper'

describe DeploymentForm do

  it { should respond_to :template_id= }
  it { should respond_to :template }
  it { should respond_to :template= }
  it { should respond_to :deployment_target_id }
  it { should respond_to :deployment_target_id= }

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
        deployment_target_id: 2
      )
      subject
    end
  end

end
