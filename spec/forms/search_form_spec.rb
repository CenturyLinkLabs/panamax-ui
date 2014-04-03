require 'spec_helper'

describe SearchForm do
  let(:fake_search_service) { double(:fake_search_service) }

  subject {
    SearchForm.new(fake_search_service)
  }

  describe '#submit' do
    it 'queries via the search service' do
      expect(fake_search_service).to receive(:search_for).with('apache')

      subject.submit({query: 'apache'})
    end
  end
end
