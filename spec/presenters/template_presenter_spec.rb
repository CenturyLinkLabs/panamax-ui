require 'spec_helper'

describe TemplatePresenter do
  let(:fake_template) do
    double(:fake_template, {
      name: 'boom shaka',
      description: 'goes boom shaka laka',
      short_description: 'goes boom',
      updated_at: 'Mon'
    })
  end

  subject { TemplatePresenter.new(fake_template) }

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

  describe '#updated_at' do
    it 'exposes the template updated_at' do
      expect(subject.updated_at).to eq 'Mon'
    end
  end
end
