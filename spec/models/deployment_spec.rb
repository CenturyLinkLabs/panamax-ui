require 'spec_helper'

describe Deployment do

  it_behaves_like 'an active resource model'

  it { should respond_to :id }
  it { should respond_to :resource_key }
  it { should respond_to :resource_type }
  it { should respond_to :override }

  describe '#to_param' do
    subject { described_class.new('id' => 77).to_param }

    it 'returns the id' do
      expect(subject).to eq 77
    end
  end

  describe '#display_name' do
    describe 'when name is provided' do
      subject{ described_class.new('id' => 77, 'name' => 'Me').display_name}
      it 'returns name' do
        expect(subject).to eq 'Me'
      end
    end

    describe 'when name is nil' do
      subject{ described_class.new('id' => 77).display_name}
      it 'returns Unnamed Deployment' do
        expect(subject).to eq 'Unnamed Deployment'
      end
    end
  end

  describe '#as_json' do
    let(:attributes) do
      {
        id: 7,
        template_id: 9,
        name: 'boom'
      }.stringify_keys
    end

    subject { described_class.new(attributes) }

    it 'provides the attributes to be converted to JSON' do
      expected = attributes.merge(
        'display_name' => 'boom'
      )
      expect(subject.as_json).to eq expected
    end
  end
end
