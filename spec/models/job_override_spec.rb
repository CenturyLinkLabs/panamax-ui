require 'spec_helper'

describe JobOverride do

  it_behaves_like 'an active resource model'

  it { should respond_to(:environment) }

  describe '#environment_attributes=' do
    let(:attrs) do
      HashWithIndifferentAccess.new(
        '0' => {
          'variable' => 'REMOTE_TARGET_NAME',
          'value' => 'bullseye'
        },
        '1' => {
          'variable' => 'CLIENT_ID',
          'value' => ''
        }
      )
    end

    it 'assigns a list of environments' do
      subject.environment_attributes = attrs
      env = subject.environment
      expect(env.first.variable).to eq 'REMOTE_TARGET_NAME'
      expect(env.first.value).to eq 'bullseye'
      expect(env.last.variable).to eq 'CLIENT_ID'
      expect(env.last.value).to eq ''
    end
  end
end
