require 'spec_helper'

describe ServicesService do
  let(:fake_connection) { double(:fake_connection) }
  let(:fake_request) { double(:fake_request) }
  let(:fake_service) { double(:fake_service, valid?: true, id: 77) }
  let(:fake_response) { double(:fake_response, body: nil, status: 200) }

  subject { ServicesService.new(fake_connection) }

  before do
    Service.stub(:build_from_response).and_return(fake_service)
  end

  describe '#create' do
    it 'posts a json representation of the params' do
      headers_hash = {}
      fake_request.stub(:headers).and_return(headers_hash)
      expect(headers_hash).to receive(:[]=).with('Content-Type', 'application/json')
      expect(fake_connection).to receive(:post).and_yield(fake_request).and_return(fake_response)
      expect(fake_request).to receive(:url).with('/apps/77/services/')
      expect(fake_request).to receive(:body=).with("{\"application_id\":\"77\"}")

      subject.create(application_id: '77')
    end

    context 'when successful' do
      let(:fake_faraday_response) do
        double(:fake_faraday_response,
          success?: true,
          body: '{}'
        )
      end

      before do
        fake_connection.stub(:post).and_return(fake_faraday_response)
      end

      it 'returns a valid service object' do
        service = subject.create(application_id: '77')
        expect(service.valid?).to be_true
      end

      it 'includes the service in the response object' do
        service = subject.create(application_id: '77')
        expect(service).to eq fake_service
      end
    end

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

  describe '#destroy' do
    it 'issues a delete request to the proper URL' do
      expect(fake_connection).to receive(:delete).with('/apps/1/services/1').and_return(fake_response)
      subject.destroy(1, 1)
    end

    it 'returns an array of the response body and response status' do
      expect(fake_connection).to receive(:delete).with('/apps/1/services/1').and_return(fake_response)
      expect(subject.destroy(1, 1)).to match_array [nil, 200]
    end
  end
end
