require 'spec_helper'

describe User do
  it 'sets the singleton name to the model_name.element' do
    expect(described_class.singleton_name).to eq 'user'
  end

  it { should respond_to :email }
  it { should respond_to :github_access_token_present }

  describe '#repositories' do
    it 'should always respond to each' do
      expect(subject.repositories).to respond_to :each
    end
  end
end
