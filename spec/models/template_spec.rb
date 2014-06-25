require 'spec_helper'

describe Template do
  let(:attributes) do
    {
      'id' => 77,
      'name' => 'boom/shaka',
      'description' => 'this thing goes boom shaka laka',
      'updated_at' => Time.parse('2012-1-13').to_s,
      'image_count' => 4,
      'type' => 'wordpress'
    }
  end

  subject { described_class.new(attributes) }

  describe '#id' do
    it { should respond_to :id }
  end

  describe '#description' do
    it { should respond_to :description }
  end

  describe '#updated_at' do
    it { should respond_to :updated_at }
  end

  describe '#name' do
    it { should respond_to :name }
  end

  describe '#image_count' do
    it { should respond_to :image_count }
  end

  describe '#recommended' do
    it { should respond_to :recommended }
  end

  describe '#icon_src' do
    it { should respond_to :icon_src }
  end

  describe '#type' do
    it { should respond_to :type }
  end

  describe '#keywords' do
    it { should respond_to :keywords }
  end

  describe '#authors' do
    it { should respond_to :authors }
  end

  describe '#from' do
    it { should respond_to :from }
  end

  describe '#documentation' do
    it { should respond_to :documentation }
  end

  describe '#short_description' do
    subject do
      long_description_attributes = attributes.merge(
        'description' => 'w' * 300
      )
      Template.new(long_description_attributes)
    end

    it 'truncates the description to 165 charectors' do
      expect(subject.short_description).to eq 'w' * 162 + '...'
    end
  end
  describe '#last_updated_on' do
    it 'exposes last_updated_on' do
      expect(subject.last_updated_on).to eq 'January 13th, 2012 00:00'
    end
  end

  describe '#image_count_label' do
    it 'exposes image_count_label' do
      expect(subject.image_count_label).to eq 'Images'
    end

    context 'with just a single image' do
      subject do
        single_image_attributes = attributes.merge('image_count' => 1)
        Template.new(single_image_attributes)
      end

      it 'returns Image instead of Images' do
        expect(subject.image_count_label).to eq 'Image'
      end
    end
  end

  describe '#icon_src' do
    it 'exposes the icon url' do
      expect(subject.icon_src).to eq '/assets/type_icons/wordpress.svg'
    end

    context 'when no image exists' do
      subject { described_class.new(attributes.merge('type' => nil)) }

      it 'returns the default image url if no image exists' do
        expect(subject.icon_src).to eq '/assets/type_icons/default.svg'
      end
    end
  end

  describe '#as_json' do
    it 'provides the attributes to be converted to JSON' do
      expected = attributes.merge(
        'short_description' => 'this thing goes boom shaka laka',
        'last_updated_on' => 'January 13th, 2012 00:00',
        'image_count_label' => 'Images',
        'recommended_class' => 'not-recommended',
        'icon_src' => '/assets/type_icons/wordpress.svg'
      )
      expect(subject.as_json).to eq expected
    end
  end
end
