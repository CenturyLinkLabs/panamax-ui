require 'spec_helper'

describe ImagePresenter do
  let(:fake_image) do
    double(:fake_image, {
      repository: 'boom/shaka',
      description: 'goes boom shaka laka',
      short_description: 'goes boom',
      status_label: 'Repository',
      star_count: 123
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

  describe '#status_label' do
    it 'exposes the image status label' do
      expect(subject.status_label).to eq 'Repository'
    end
  end

  describe '#star_count' do
    it 'exposes the star count' do
      expect(subject.star_count).to eq 123
    end
  end
end
