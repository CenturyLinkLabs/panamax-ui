require 'spec_helper'

describe CategoryPresenter do
  let(:fake_group) do
    double(:fake_group,
      name: 'shaka',
      id: 77
    )
  end
  let(:fake_service) do
    double(:fake_service,
      name: 'boom_service'
    )
  end
  let(:fake_services) do
    double(:fake_services,
      first: fake_service
    )
  end

  subject { CategoryPresenter.new(fake_group, fake_services) }

  describe '#name' do
    it 'exposes the category name' do
      expect(subject.name).to eq 'shaka'
    end
  end

  describe '#id' do
    it 'exposes the category id' do
      expect(subject.id).to eq 77
    end
  end

  describe '#services' do
    it 'exposes the category services' do
      expect(subject.services.first.name).to eq 'boom_service'
    end
  end
end
