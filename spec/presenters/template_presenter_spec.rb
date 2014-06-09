require 'spec_helper'

describe TemplatePresenter do
  let(:fake_template) do
    double(:fake_template, {
      id: 99,
      name: 'boom shaka',
      description: 'goes boom shaka laka',
      short_description: 'goes boom',
      last_updated_on: 'Mon',
      image_count: 5,
      image_count_label: 'Images',
      recommended_class: 'not-recommended',
      icon_src: '/icons/icon.png'
    })
  end

  subject { TemplatePresenter.new(fake_template) }

  describe '#id' do
    it 'exposes the template id' do
      expect(subject.id).to eq 99
    end
  end

  describe '#title' do
    it 'exposes the template name' do
      expect(subject.title).to eq 'boom shaka'
    end
  end

  describe '#short_description' do
    it 'exposes the template short description' do
      expect(subject.short_description).to eq 'goes boom'
    end
  end

  describe '#description' do
    it 'exposes the template description' do
      expect(subject.description).to eq 'goes boom shaka laka'
    end
  end

  describe '#last_updated_on' do
    it 'exposes the template last_updated_on' do
      expect(subject.last_updated_on).to eq 'Mon'
    end
  end

  describe '#image_count' do
    it 'exposes the template image_count' do
      expect(subject.image_count).to eq 5
    end
  end

  describe '#image_count_label' do
    it 'exposes the template image_count_label' do
      expect(subject.image_count_label).to eq 'Images'
    end
  end

  describe '#recommended_class' do
    it 'exposes the template recommended_class value' do
      expect(subject.recommended_class).to eq 'not-recommended'
    end
  end

  describe '#icon_src' do
    it 'exposes the icon_src src' do
      expect(subject.icon_src).to eq '/icons/icon.png'
    end
  end
end
