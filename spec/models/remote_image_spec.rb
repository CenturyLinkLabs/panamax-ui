require 'spec_helper'

describe RemoteImage do

  it_behaves_like 'an image'

  let(:attributes) do
    {
      'id' => 77,
      'source' => 'boom/shaka',
      'description' => 'this thing goes boom shaka laka',
      'star_count' => 127,
      'is_trusted' => false,
      'is_official' => false
    }
  end

  subject { described_class.new(attributes) }

  describe '#remote?' do
    it 'is a remote image' do
      expect(subject.remote?).to be_true
    end
  end

  describe '#docker_index_url' do

    context 'for official images' do
      subject { described_class.new('source' => 'shaka') }

      it 'composes a docker index URL' do
        expect(subject.docker_index_url).to eq "#{DOCKER_INDEX_BASE_URL}_/shaka"
      end
    end

    context 'for unofficial images' do
      subject { described_class.new('source' => 'boom/shaka') }

      it 'composes a docker index URL' do
        expect(subject.docker_index_url).to eq "#{DOCKER_INDEX_BASE_URL}u/boom/shaka"
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
      expected = attributes.merge(
        'short_description' => 'this thing goes boom shaka laka',
        'status_label' => 'Repository',
        'badge_class' => 'repository',
        'docker_index_url' => "#{DOCKER_INDEX_BASE_URL}u/boom/shaka"
      )
      expect(subject.as_json).to eq expected
    end
  end
end
