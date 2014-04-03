require 'spec_helper'

describe SearchService do
  let(:fake_connection) { double(:fake_connection) }

  describe '#search_for' do
    subject {
      SearchService.new(fake_connection)
    }

    context 'when successfull' do
      let(:fake_response) { double(:fake_response, body: '{}') }
      let(:fake_search_result_set) { double(:fake_search_result_set) }

      before do
        SearchResultSet.stub(:create_from_response).and_return(fake_search_result_set)
      end

      it 'makes a request to the external API to get the results' do
        expect(fake_connection).to receive('get').with('/search', {q: 'apache'}).and_return(fake_response)
        subject.search_for('apache')
      end

      it 'returns a search result set object' do
        fake_connection.stub(:get).and_return(fake_response)
        result = subject.search_for('apache')

        expect(result).to eql fake_search_result_set
      end
    end
  end
end
