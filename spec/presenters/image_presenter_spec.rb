require 'spec_helper'

describe ImagePresenter do
  let(:fake_image) do
    double(:fake_image, {
      repository: 'boom/shaka',
      description: 'goes boom shaka laka',
      updated_at: 'Mon',
      status_label: 'Repository'
    })
  end

  subject { ImagePresenter.new(fake_image) }

  describe '#title' do
    it 'exposes the image repository' do
      expect(subject.title).to eq 'boom/shaka'
    end
  end

  describe '#description' do
    it 'exposes the image description' do
      expect(subject.description).to eq 'goes boom shaka laka'
    end
  end

  describe '#updated_at' do
    it 'exposes the image updated_at' do
      expect(subject.updated_at).to eq 'Mon'
    end
  end

  describe '#status_label' do
    it 'exposes the image status label' do
      expect(subject.status_label).to eq 'Repository'
    end
  end
end
