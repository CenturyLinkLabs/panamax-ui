require 'spec_helper'

describe Image do
  let(:attributes) do
    {
      'id' => 77,
      'repository' => 'boom/shaka',
      'description' => 'this thing goes boom shaka laka',
      'updated_at' => 'Mon'
    }
  end

  subject { Image.new(attributes) }
  describe '#id' do
    it 'exposes an id' do
      expect(subject.id).to eq 77
    end
  end

  describe '#repository' do
    it 'exposes a repository repository' do
      expect(subject.repository).to eq 'boom/shaka'
    end
  end

  describe '#description' do
    it 'exposes a description' do
      expect(subject.description).to eq 'this thing goes boom shaka laka'
    end
  end

  describe '#updated_at' do
    it 'exposes updated_at' do
      expect(subject.updated_at).to eq 'Mon'
    end
  end

  describe '#as_json' do
    it 'provides the attributes to be converted to JSON' do
      expected = {
        'id' => 77,
        'repository' => 'boom/shaka',
        'description' => 'this thing goes boom shaka laka',
        'updated_at' => 'Mon'
      }
      expect(subject.as_json).to eq expected
    end
  end
end
