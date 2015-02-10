require 'spec_helper'

describe Job do
  it_behaves_like 'an active resource model'

  it { should respond_to :template_id }
  it { should respond_to :steps }

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

  describe '#with_template!' do
    let(:fake_template) { double(:fake_template) }

    before do
      subject.job_template_id = 9
      allow(JobTemplate).to receive(:find).with(9).and_return(fake_template)
    end

    it 'fetches and assigns the template' do
      expect(subject.template).to be_nil
      subject.with_template!
      expect(subject.template).to eq fake_template
    end
  end

  describe '#with_log!' do
    let(:fake_new_job) { double(:fake_new_job) }
    before do
      subject.key = 7
      allow(Job).to receive(:new).with(id: 7).and_return(fake_new_job)
      allow(fake_new_job).to receive(:get).with(:log).and_return(['log'])
    end

    it 'fetches and assigns the log' do
      expect(subject.log).to be_nil
      subject.with_log!
      expect(subject.log).to eq ['log']
    end
  end

  describe '#with_step_status!' do
    let(:step1) { Step.new }
    let(:step2) { Step.new }

    before do
      subject.status = 'complete'
      subject.completed_steps = 2
      subject.steps = [step1, step2]
      allow(step1).to receive(:update_status!)
      allow(step2).to receive(:update_status!)
    end

    it 'hydrates each child step with a status' do
      subject.with_step_status!
      expect(step1).to have_received(:update_status!).with(2, false)
      expect(step2).to have_received(:update_status!).with(2, false)
    end

    it 'returns itself for chaining' do
      expect(subject.with_step_status!).to eq subject
    end
  end

  describe 'success?' do
    it 'is true when status is complete' do
      subject.status = 'complete'
      expect(subject.success?).to be_true
    end

    it 'is false when status in anything else' do
      results = [false, nil, 'in-progress'].map do |status|
        subject.status = status
        subject.success?
      end
      expect(results).to eq 3.times.map { false }
    end
  end

  describe 'running?' do
    it 'is true when status is running' do
      subject.status = 'running'
      expect(subject.running?).to be_true
    end

    it 'is false when status in anything else' do
      results = [false, nil, 'complete'].map do |status|
        subject.status = status
        subject.running?
      end
      expect(results).to eq 3.times.map { false }
    end
  end

  describe 'failure?' do
    it 'is true when status is error' do
      subject.status = 'error'
      expect(subject.failure?).to be_true
    end

    it 'is false when status in anything else' do
      results = [false, nil, 'in-progress'].map do |status|
        subject.status = status
        subject.failure?
      end
      expect(results).to eq 3.times.map { false }
    end
  end

  describe '#total_steps' do
    subject do
      described_class.new(
        steps: [1, 2]
      )
    end

    it 'returns the step count' do
      expect(subject.total_steps).to eq 2
    end
  end

  describe '#as_json' do
    it 'provides the attributes to be converted to JSON' do
      subject.name = 'booyah'
      expect(subject.as_json.keys).to match_array ['name', 'running', 'failure', 'success']
    end
  end
end
