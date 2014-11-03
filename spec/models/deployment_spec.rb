require 'spec_helper'

describe Deployment do

  it_behaves_like 'an active resource model'

  it { should respond_to :id }
  it { should respond_to :template_id }
  it { should respond_to :override }

  describe '#to_param' do
    subject { described_class.new('id' => 77).to_param }

    it 'returns the id' do
      expect(subject).to eq 77
    end
  end

end
