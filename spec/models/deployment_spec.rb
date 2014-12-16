require 'spec_helper'

describe Deployment do

  it_behaves_like 'an active resource model'

  it { should respond_to :id }
  it { should respond_to :resource_id }
  it { should respond_to :resource_type }
  it { should respond_to :override }

  describe '#redeploy' do
    let(:fake_response) { double(:fake_response,  body: '{"id": 14}') }
    before { allow(subject).to receive(:post).and_return(fake_response) }

    it 'posts to the redeploy endpoint' do
      expect(subject).to receive(:post).with(:redeploy)
      subject.redeploy
    end

    it 'returns a new Deployment' do
      expect(subject.redeploy).to be_a Deployment
    end

    it 'returns a new Deployment instantiated from the response body' do
      expect(subject.redeploy.id).to eq 14
    end
  end

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
