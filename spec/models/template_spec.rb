require 'spec_helper'

describe Template do
  let(:attributes) do
    {
      'id' => 77,
      'name' => 'boom/shaka',
      'description' => 'this thing goes boom shaka laka',
      'updated_at' => Time.parse('2012-1-13').to_s
    }
  end

  subject { Template.new(attributes) }
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

  describe '#short_description' do
    subject do
      long_description_attributes = attributes.merge({
        'description' => 'w'*300
      })
      Template.new(long_description_attributes)
    end

    it 'truncates the description to 165 charectors' do
      expect(subject.short_description).to eq 'w'*162 + '...'
    end
  end

  describe '#description' do
    it 'exposes a description' do
      expect(subject.description).to eq 'this thing goes boom shaka laka'
    end
  end

  describe '#updated_at' do
    it 'exposes updated_at' do
      expect(subject.updated_at).to eq 'January 13th, 2012 00:00'
    end
  end

  describe '#as_json' do
    it 'provides the attributes to be converted to JSON' do
      expected = {
        'id' => 77,
        'name' => 'boom/shaka',
        'description' => 'this thing goes boom shaka laka',
        'short_description' => 'this thing goes boom shaka laka',
        'updated_at' => 'January 13th, 2012 00:00'
      }
      expect(subject.as_json).to eq expected
    end
  end
end
