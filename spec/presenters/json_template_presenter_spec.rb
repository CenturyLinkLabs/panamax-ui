require 'spec_helper'

describe JsonTemplatePresenter do
  describe '#id' do
    it 'returns the handlebar template tag for id' do
      expect(subject.id).to eq '{{id}}'
    end
  end

  describe '#title' do
    it 'returns the handlebar template tag for name' do
      expect(subject.title).to eq '{{name}}'
    end
  end

  describe '#short_description' do
    it 'exposes the handlebar template tag for short description' do
      expect(subject.short_description).to eq '{{short_description}}'
    end
  end

  describe '#description' do
    it 'exposes the handlebar template tag for description' do
      expect(subject.description).to eq '{{description}}'
    end
  end

  describe '#last_updated_on' do
    it 'exposes the handlebar template tag for updated at' do
      expect(subject.last_updated_on).to eq '{{last_updated_on}}'
    end
  end

  describe '#image_count' do
    it 'exposes the handlebar template tag for image count' do
      expect(subject.image_count).to eq '{{image_count}}'
    end
  end

  describe '#image_count_label' do
    it 'exposes the handlebar template tag for image count label' do
      expect(subject.image_count_label).to eq '{{image_count_label}}'
    end
  end

  describe '#icon_src' do
    it 'exposes the handlebar template tag for icon src' do
      expect(subject.icon_src).to eq '{{icon_src}}'
    end
  end
end
