require 'spec_helper'

describe Template do
  let(:attributes) do
    {
      'id' => 77,
      'name' => 'boom/shaka',
      'description' => 'this thing goes boom shaka laka',
      'updated_at' => Time.parse('2012-1-13').to_s,
      'image_count' => 4,
      'icon' => 'http://iconwarehouse.io/myicon.png'
    }
  end

  it_behaves_like 'a view model', {
    'id' => 77,
    'name' => 'boom/shaka',
    'description' => 'this thing goes boom shaka laka',
    'image_count' => 4
  }

  it_behaves_like 'a collection builder', [
    {
      'id' => 77,
      'name' => 'boom/shaka'
    },
    {
      'id' => 87,
      'name' => 'foo/bar'
    }
  ]

  subject { Template.new(attributes) }

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
  describe '#updated_at' do
    it 'exposes updated_at' do
      expect(subject.updated_at).to eq 'January 13th, 2012 00:00'
    end
  end

  describe '#image_count_label' do
    it 'exposes image_count_label' do
      expect(subject.image_count_label).to eq 'Images'
    end

    context 'with just a single image' do
      subject do
        single_image_attributes = attributes.merge({
          'image_count' => 1
        })
        Template.new(single_image_attributes)
      end

      it 'returns Image instead of Images' do
        expect(subject.image_count_label).to eq 'Image'
      end
    end
  end

  describe '#icon' do
    it 'exposes the icon url' do
      expect(subject.icon).to eq 'http://iconwarehouse.io/myicon.png'
    end

    context 'when no image exists' do
      subject { described_class.new(attributes.merge('icon' => nil)) }

      it 'returns the default image url if no image exists' do
        expect(subject.icon).to eq '/assets/template_logos/default.png'
      end
    end
  end

  describe '#as_json' do
    it 'provides the attributes to be converted to JSON' do
      expected = {
        'id' => 77,
        'name' => 'boom/shaka',
        'description' => 'this thing goes boom shaka laka',
        'short_description' => 'this thing goes boom shaka laka',
        'updated_at' => 'January 13th, 2012 00:00',
        'image_count' => 4,
        'image_count_label' => 'Images',
        'recommended_class' => 'not-recommended',
        'icon' => 'http://iconwarehouse.io/myicon.png'
      }
      expect(subject.as_json).to eq expected
    end
  end
end
