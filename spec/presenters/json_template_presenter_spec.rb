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

  describe '#updated_at' do
    it 'exposes the handlebar template tag for updated at' do
      expect(subject.updated_at).to eq '{{updated_at}}'
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

  describe '#recommended_class' do
    it 'exposes the template recommended class label' do
      expect(subject.recommended_class).to eq '{{recommended_class}}'
    end
  end
end
