require 'spec_helper'

describe ImagePresenter do
  let(:fake_image) do
    double(:fake_image, {
      name: 'boom/shaka',
      description: 'goes boom shaka laka',
      updated_at: 'Mon'
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

  describe '#updated_at' do
    it 'exposes the image updated_at' do
      expect(subject.updated_at).to eq 'Mon'
    end
  end
end
