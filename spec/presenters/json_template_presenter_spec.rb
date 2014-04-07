require 'spec_helper'

describe JsonTemplatePresenter do
  describe '#title' do
    it 'returns the handlebar template tag for name' do
      expect(subject.title).to eq '{{name}}'
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
end
