require 'spec_helper'

describe Image do
  let(:attributes) do
    {
      'id' => 77,
      'info' => {
        'name' => 'boom/shaka',
        'description' => 'this thing goes boom shaka laka'
      }
    }
  end

  subject { Image.new(attributes) }
  describe '#id' do
    it 'exposes an id' do
      expect(subject.id).to eq 77
    end
  end

  describe '#name' do
    it 'exposes a name' do
      expect(subject.name).to eq 'boom/shaka'
    end
  end

  describe '#description' do
    it 'exposes a description' do
      expect(subject.description).to eq 'this thing goes boom shaka laka'
    end
  end

  describe '#as_json' do
    it 'provides the attributes to be converted to JSON' do
      expected = {
        'id' => 77,
        'name' => 'boom/shaka',
        'description' => 'this thing goes boom shaka laka'
      }
      expect(subject.as_json).to eq expected
    end
  end
end
