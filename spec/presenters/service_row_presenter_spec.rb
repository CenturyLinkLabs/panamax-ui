require 'spec_helper'

describe ServiceRowPresenter do
  let(:fake_app) do
    double(:fake_app,
      id: 77
    )
  end
  let(:fake_service) do
    double(:fake_group,
      id: 99,
      name: 'shaka',
      icon: 'shaka.svg',
      status: 'loading',
      app: fake_app
    )
  end

  subject { ServiceRowPresenter.new(fake_service) }

  describe '#name' do
    it 'exposes the service name' do
      expect(subject.name).to eq 'shaka'
    end
  end

  describe '#icon' do
    it 'exposes the service icon' do
      expect(subject.icon).to eq 'shaka.svg'
    end
  end

  describe '#status' do
    it 'exposes the service status' do
      expect(subject.status).to eq 'loading'
    end
  end

  describe '#service_url' do
    it 'exposes the service_url' do
      expect(subject.service_url).to eq '/apps/77/services/99'
    end
  end
end
