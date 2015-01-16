require 'spec_helper'

describe Job do
  it_behaves_like 'an active resource model'

  it { should respond_to :template_id }

  describe '.new_from_template' do
    let(:fake_template) { double(:fake_template, environment: 'some environment stuff', id: 9) }

    it 'instantiates itself with attributes from the template' do
      instance = described_class.new_from_template(fake_template)
      expect(instance.override.environment).to eq 'some environment stuff'
      expect(instance.template_id).to eq 9
    end
  end

  describe '.nested_create' do
    let(:attrs) do
      HashWithIndifferentAccess.new(
        'template_id' => '9',
        'job_override_attributes' => {
          'environment_attributes' => {
            '0' => {
              'variable' => 'REMOTE_TARGET_NAME',
              'value' => ''
            },
            '1' => {
              'variable' => 'CLIENT_ID',
              'value' => ''
            }
          }
        }
      )
    end

    let(:fake_instance) { double(:fake_instance, write_attributes: true, save: true) }

    before do
      allow(described_class).to receive(:new).with(template_id: '9').and_return(fake_instance)
    end

    it 'carefully assembles the object so ActiveResource does not freak out' do
      described_class.nested_create(attrs)
      expect(fake_instance).to have_received(:write_attributes).with(attrs)
      expect(fake_instance).to have_received(:save)
    end
  end

  describe '#override_attributes=' do
    let(:attrs) do
      {
        'environment_attributes' => {
          '0' => {
            'variable' => 'REMOTE_TARGET_NAME',
            'value' => 'bullseye'
          },
          '1' => {
            'variable' => 'CLIENT_ID',
            'value' => ''
          }
        }
      }
    end

    it 'assigns the override' do
      subject.override_attributes = attrs
      env = subject.override.environment
      expect(env.first.variable).to eq 'REMOTE_TARGET_NAME'
      expect(env.first.value).to eq 'bullseye'
      expect(env.last.variable).to eq 'CLIENT_ID'
      expect(env.last.value).to eq ''
    end
  end
end
