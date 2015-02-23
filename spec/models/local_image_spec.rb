require 'spec_helper'

describe LocalImage do

  it_behaves_like 'an image'

  let(:attributes) do
    {
      'id' => 77,
      'tags' => ['blah/not-panamax'],
      'source' => 'boom/shaka',
      'description' => 'this thing goes boom shaka laka',
      'star_count' => 127,
      'is_trusted' => false,
      'is_official' => false
    }
  end

  subject { described_class.new(attributes) }

  describe '#local?' do
    it 'is a local image' do
      expect(subject.local?).to be_truthy
    end
  end

  describe '#panamax_image?' do
    let(:panamax_ui) do
      {
        'tags' => ['centurylink/panamax-ui:latest']
      }
    end

    let(:panamax_api) do
      {
        'tags' => ['centurylink/panamax-api:latest']
      }
    end

    it 'is true when name is centurylink/panamax-ui' do
      pmx_ui = described_class.new(panamax_ui)
      expect(pmx_ui.panamax_image?).to be_truthy
    end

    it 'is true when name is centurylink/panamax-api' do
      pmx_api = described_class.new(panamax_api)
      expect(pmx_api.panamax_image?).to be_truthy
    end

    it 'is false when name is not panamax image' do
      expect(subject.panamax_image?).to be_falsey
    end
  end

  describe '#docker_index_url' do
    it 'is nil' do
      expect(subject.docker_index_url).to be_nil
    end
  end

  describe '.batch_destroy' do
    describe 'when successful' do
      let(:fake_image) { double(:fake_image, id: 1, destroy: true) }

      before do
        allow(LocalImage).to receive(:find_by_id).and_return(fake_image)
      end

      it 'calls #destroy on all the image provided' do
        expect(fake_image).to receive(:destroy)
        LocalImage.batch_destroy [1]
      end

      it 'returns the count of successfully removed images' do
        result = LocalImage.batch_destroy [1, 2, 3, 4, 5]
        expect(result[:count]).to eq 5
      end
    end

    describe 'with failures' do
      let(:fake_image) { double(:fake_image, name: 'bad_image', destroy: false) }

      before do
        allow(LocalImage).to receive(:find_by_id).and_return(fake_image)
      end

      it 'returns the set of failed images' do
        result = LocalImage.batch_destroy [1]
        expect(result[:count]). to eq 0
        expect(result[:failed].to_a).to match_array ['bad_image failed to be removed']
      end
    end

    describe 'with errors' do
      let(:fake_image) { double(:fake_image, id: 1, destroy: true) }

      before do
        allow(LocalImage).to receive(:find_by_id).and_return(fake_image)
        allow(fake_image).to receive(:destroy).and_raise(StandardError, 'oops')
      end

      it 'returns the set of failed error messages' do
        result = LocalImage.batch_destroy [1]
        expect(result[:failed].to_a).to match_array ['oops']
      end
    end
  end

  describe '#status_label' do
    it 'is local by default' do
      expect(subject.status_label).to eql 'Local'
    end
  end

  describe '#as_json' do
    it 'provides the attributes to be converted to JSON' do
      expected = attributes.merge(
        'short_description' => 'this thing goes boom shaka laka',
        'status_label' => 'Local',
        'badge_class' => 'local',
        'docker_index_url' => nil
      )
      expect(subject.as_json).to eq expected
    end
  end
end
