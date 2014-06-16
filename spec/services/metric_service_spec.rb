require 'spec_helper'

describe CadvisorService do
  let(:fake_connection) { double(:fake_connection) }
  let(:fake_request) { double(:fake_request) }
  let(:fake_response) { double(:fake_response, body: '[{}]', status: 200) }

  subject { CadvisorService.new(fake_connection) }

  describe '#all' do
    it 'issues a get request to the proper URL' do
      expect(fake_connection).to receive(:get).with('/api/v1.0/containers/').and_return(fake_response)
      subject.all
    end

    it 'returns a list of metrics' do
      fake_connection.stub(:get).and_return(fake_response)
      result = subject.all
      expect(result).to match_array [{}]
    end
  end
end
