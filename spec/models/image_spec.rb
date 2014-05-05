require 'spec_helper'

describe Image do
  let(:attributes) do
    {
      'id' => 77,
      'repository' => 'boom/shaka',
      'description' => 'this thing goes boom shaka laka',
      'star_count' => 127
    }
  end

  it_behaves_like 'a view model', {
    'id' => 77,
    'repository' => 'boom/shaka',
    'description' => 'this thing goes boom shaka laka',
    'star_count' => 127,
    'location' => 'remote'
  }

  it_behaves_like 'a collection builder', [
    {
      'id' => 77,
      'repository' => 'foo/bar'
    },
    {
      'id' => 77,
      'repository' => 'boom/shaka'
    }
  ]

  subject { described_class.new(attributes) }

  describe '#docker_index_url' do
    context 'when a remote image' do

      context 'for official images' do
        subject { described_class.new('location' => described_class.locations[:remote], 'repository' => 'shaka') }

        it 'composes a docker index URL' do
          expect(subject.docker_index_url).to eq 'https://index.docker.io/_/shaka'
        end
      end

      context 'for unofficial images' do
        subject { described_class.new('location' => described_class.locations[:remote], 'repository' => 'boom/shaka') }

        it 'composes a docker index URL' do
          expect(subject.docker_index_url).to eq 'https://index.docker.io/u/boom/shaka'
        end
      end
    end

    context 'when a local image' do
      subject { described_class.new(location: described_class.locations[:local]) }

      it 'returns nil' do
        expect(subject.docker_index_url).to be_nil
      end
    end
  end

  describe '#short_description' do
    subject do
      long_description_attributes = attributes.merge({
        'description' => 'w'*300
      })
      described_class.new(long_description_attributes)
    end

    it 'truncates the description to 165 charectors' do
      expect(subject.short_description).to eq 'w'*162 + '...'
    end
  end

  describe '#status_label' do
    it 'is repository by default' do
      expect(subject.status_label).to eql 'Repository'
    end

    context 'when the trusted flag is set' do
      subject do
        described_class.new(attributes.merge({'is_trusted' => true}))
      end

      it 'is trusted' do
        expect(subject.status_label).to eql 'Trusted'
      end
    end

    context 'when both trusted and recommended are set' do
      subject do
        modified_attributes = attributes.merge({
          'is_trusted' => true,
          'recommended' => true
        })
        described_class.new(modified_attributes)
      end

      it 'is recommended if both the trusted and recommended flags are set' do
        expect(subject.status_label).to eql 'Recommended'
      end
    end

    context 'when type local is set' do
      subject do
        described_class.new(attributes.merge({'location' => described_class.locations[:local]}))
      end

      it 'is local' do
        expect(subject.status_label).to eql 'Local'
      end
    end
  end

  describe '#remote?' do
    it 'is true for a remote image' do
      subject = described_class.new('location' => described_class.locations[:remote])
      expect(subject.remote?).to be_true
    end

    it 'is falsey for a non-remote image' do
      expect(subject.remote?).to be_false
    end
  end

  describe '.locations' do
    it 'is a hash of possible location values' do
      expected_hash = {
        remote: :remote,
        local: :local
      }
      expect(described_class.locations).to eq expected_hash
    end
  end

  describe '#local?' do
    it 'is true for a local image' do
      subject = described_class.new('location' => described_class.locations[:local])
      expect(subject.local?).to be_true
    end

    it 'is falsey for a non-local image' do
      expect(subject.local?).to be_false
    end
  end

  describe '#as_json' do
    it 'provides the attributes to be converted to JSON' do
      expected = {
        'id' => 77,
        'repository' => 'boom/shaka',
        'description' => 'this thing goes boom shaka laka',
        'short_description' => 'this thing goes boom shaka laka',
        'status_label' => 'Repository',
        'location' => nil,
        'star_count' => 127,
        'recommended_class' => 'not-recommended',
        'docker_index_url' => nil
      }
      expect(subject.as_json).to eq expected
    end
  end
end
