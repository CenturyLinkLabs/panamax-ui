require 'spec_helper'

describe ImagePresenter do
  let(:fake_image) do
    double(:fake_image, {
      name: 'boom/shaka',
      description: 'goes boom shaka laka'
    })
  end

  subject { ImagePresenter.new(fake_image) }

  describe '#name' do
    it 'exposes the image name' do
      expect(subject.name).to eq 'boom/shaka'
    end
  end

  describe '#description' do
    it 'exposes the image description' do
      expect(subject.description).to eq 'goes boom shaka laka'
    end
  end
end
