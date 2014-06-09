require 'spec_helper'

describe RemoteImage do

  it_behaves_like 'an image'

  let(:attributes) do
    {
      'id' => 77,
      'repository' => 'boom/shaka',
      'description' => 'this thing goes boom shaka laka',
      'star_count' => 127,
      'recommended' => false,
      'is_trusted' => false
    }
  end

  subject {
    described_class.new(attributes)
  }

  describe '#remote?' do
    it 'is a remote image' do
      expect(subject.remote?).to be_true
    end
  end

  describe '#docker_index_url' do

    context 'for official images' do
      subject { described_class.new('repository' => 'shaka') }

      it 'composes a docker index URL' do
        expect(subject.docker_index_url).to eq 'https://index.docker.io/_/shaka'
      end
    end

    context 'for unofficial images' do
      subject { described_class.new('repository' => 'boom/shaka') }

      it 'composes a docker index URL' do
        expect(subject.docker_index_url).to eq 'https://index.docker.io/u/boom/shaka'
      end
    end
  end

  describe '#status_label' do
    it 'is repository by default' do
      expect(subject.status_label).to eql 'Repository'
    end
  end

  describe '#as_json' do
    it 'provides the attributes to be converted to JSON' do
      expected = attributes.merge({
        'short_description' => 'this thing goes boom shaka laka',
        'status_label' => 'Repository',
        'recommended_class' => 'not-recommended',
        'docker_index_url' => 'https://index.docker.io/u/boom/shaka'
      })
      expect(subject.as_json).to eq expected
    end
  end
end
