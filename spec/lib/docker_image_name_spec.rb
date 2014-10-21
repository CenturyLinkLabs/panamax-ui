require 'spec_helper'

describe DockerImageName do
  describe '#base_image' do
    context 'when the source is from a private registry' do
      subject { described_class.new('192.168.2.2:5555/ctl/booyah:latest').base_image }

      it { should eq '192.168.2.2:5555/ctl/booyah' }
    end

    context 'when the source is from docker hub' do
      subject { described_class.new('ctl/booyah:latest').base_image }

      it { should eq 'ctl/booyah' }
    end
  end

  describe '#tag' do
    context 'when port information exists' do
      subject { described_class.new('192.168.2.2:5555/ctl/booyah:latest').tag }

      it { should eq 'latest' }
    end

    context 'when no port information exists' do
      subject { described_class.new('ctl/booyah:latest').tag }

      it { should eq 'latest' }
    end

    context 'when there is no tag' do
      subject { described_class.new('ctl/booyah').tag }

      it { should be_nil }
    end
  end
end

