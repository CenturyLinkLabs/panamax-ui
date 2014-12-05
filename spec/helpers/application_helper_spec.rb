require 'spec_helper'

describe ApplicationHelper do
  before do
    helper.request.host = 'localhost'
  end

  describe '#metrics_url' do

    it 'returns host health value' do
      expect(helper.metrics_url).to eq 'http://localhost:3002/'
    end
  end

  describe '#metrics_url_for' do
    it 'returns  service path appended' do
      expect(helper.metrics_url_for('ME')).to eq 'http://localhost:3002/docker/ME'
    end
  end

  describe '#none_if' do
    it 'returns none if the condition is true' do
      expect(helper.none_if(true)).to eq 'none'
    end

    it 'returns nil if the condition is false' do
      expect(helper.none_if(false)).to be_nil
    end
  end

  describe '#formatted_title' do
    context 'when no page_title exists' do
      subject { helper.formatted_title(nil) }

      it { should eq 'Panamax' }
    end

    context 'when the page title does exist' do
      subject { helper.formatted_title('pretty pictures') }

      it { should eq 'Panamax > pretty pictures' }
    end

    context 'when multiple titles are passed' do
      subject { helper.formatted_title('pretty pictures', 'more pretty') }

      it { should eq 'Panamax > pretty pictures > more pretty' }
    end
  end
end
