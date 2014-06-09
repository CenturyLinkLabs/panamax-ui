require 'spec_helper'

describe SearchService do
  let(:fake_connection) { double(:fake_connection) }

  subject { SearchService.new(fake_connection) }

  describe '#tags_for' do

    let(:repository_name) { 'foo' }
    let(:fake_response) { double(:fake_response, body: "[\"foo\", \"bar\"]") }

    it 'makes a request to the external API to get the results' do
      expect(fake_connection).to receive('get')
                                   .with("/repositories/#{repository_name}/tags", { local_image: false })
                                   .and_return(fake_response)
      subject.tags_for(repository_name)
    end

    it 'returns a hash of tags' do
      fake_connection.stub(:get).and_return(fake_response)
      expect(subject.tags_for(repository_name)).to match_array(['foo', 'bar'])
    end
  end
end
