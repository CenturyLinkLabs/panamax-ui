require 'spec_helper'

describe ServicesService do
  let(:fake_connection) { double(:fake_connection) }
  let(:fake_req) { double(:fake_request) }
  let(:fake_service) { double(:fake_service, valid?: true, id: 77) }
  let(:fake_response) { double(:fake_response, body: nil, status: 200) }

  subject { ServicesService.new(fake_connection) }

  before do
    Service.stub(:build_from_response).and_return(fake_service)
  end

  describe '#find_by_id' do
    it 'issues a get request to the proper URL' do
      expect(fake_connection).to receive(:get).with('/apps/77/services/89').and_return(fake_response)
      subject.find_by_id(77, 89)
    end

    it 'creates an app instance' do
      fake_connection.stub(:get).and_return(fake_response)
      expect(Service).to receive(:build_from_response).and_return(fake_service)
      subject.find_by_id(77, 89)
    end

    it 'returns the created app instance' do
      fake_connection.stub(:get).and_return(fake_response)
      Service.stub(:build_from_response).and_return(fake_service)
      result = subject.find_by_id(77, 89)
      expect(result).to eq fake_service
    end

    context 'when status is 404' do
      let(:not_found_response) { double(:not_found_response, status: 404) }

      it 'returns nil' do
        fake_connection.stub(:get).and_return(not_found_response)
        result = subject.find_by_id(3456, 802)
        expect(result).to be_nil
      end
    end
  end
end
