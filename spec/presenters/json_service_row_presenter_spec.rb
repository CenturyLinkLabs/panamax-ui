require 'spec_helper'

describe JsonServiceRowPresenter do
  describe '#name' do
    it 'returns the handlebar template tag for name' do
      expect(subject.name).to eq '{{name}}'
    end
  end

  describe '#service_url' do
    it 'exposes the handlebar template tag for service_url' do
      expect(subject.service_url).to eq '{{service_url}}'
    end
  end

  describe '#status' do
    it 'exposes the handlebar template tag for status' do
      expect(subject.status).to eq '{{status}}'
    end
  end

  describe '#icon' do
    it 'exposes the handlebar template tag for icon' do
      expect(subject.icon).to eq '{{icon}}'
    end
  end
end
