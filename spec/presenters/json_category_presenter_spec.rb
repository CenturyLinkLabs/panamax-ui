require 'spec_helper'

describe JsonCategoryPresenter do
  describe '#name' do
    it 'returns the handlebar template tag for name' do
      expect(subject.name).to eq '{{name}}'
    end
  end

  describe '#id' do
    it 'exposes the handlebar template tag for id' do
      expect(subject.id).to eq '{{id}}'
    end
  end

  describe '#services' do
    it 'returns an empty service array' do
      expect(subject.services).to match_array([])
    end
  end
end
