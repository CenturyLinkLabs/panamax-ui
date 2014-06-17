require 'spec_helper'

describe LocalImage do

  it_behaves_like 'an image'

  let(:attributes) do
    {
      'id' => 77,
      'repository' => 'boom/shaka',
      'description' => 'this thing goes boom shaka laka',
      'star_count' => 127,
      'recommended' => false,
      'is_trusted' => false
    }
  end

  subject { described_class.new(attributes) }

  describe '#local?' do
    it 'is a local image' do
      expect(subject.local?).to be_true
    end
  end

  describe '#docker_index_url' do
    it 'is nil' do
      expect(subject.docker_index_url).to be_nil
    end
  end

  describe '#status_label' do
    it 'is local by default' do
      expect(subject.status_label).to eql 'Local'
    end
  end

  describe '#as_json' do
    it 'provides the attributes to be converted to JSON' do
      expected = attributes.merge(
        'short_description' => 'this thing goes boom shaka laka',
        'status_label' => 'Local',
        'recommended_class' => 'not-recommended',
        'docker_index_url' => nil
      )
      expect(subject.as_json).to eq expected
    end
  end
end
