require 'spec_helper'

describe JsonImagePresenter do
  describe '#name' do
    it 'returns the handlebar template tag for name' do
      expect(subject.name).to eq '{{name}}'
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
