require 'spec_helper'

describe ApplicationsService do
  let(:fake_connection) { double(:fake_connection) }
  let(:fake_request) { double(:fake_request) }
  let(:fake_app) { double(:fake_app, valid?: true, id: 77) }
  let(:fake_response) { double(:fake_response, body: nil, status: 200) }
  let(:fake_apps_response) { double(:fake_apps_response, body: '[]', status: 200)}

  subject { ApplicationsService.new(fake_connection) }

  before do
    App.stub(:build_from_response).and_return(fake_app)
  end

  describe '#find_by_id' do
    it 'issues a get request to the proper URL' do
      expect(fake_connection).to receive(:get).with('/apps/77').and_return(fake_response)
      subject.find_by_id(77)
    end

    it 'creates an app instance' do
      fake_connection.stub(:get).and_return(fake_response)
      expect(App).to receive(:build_from_response).and_return(fake_app)
      subject.find_by_id(77)
    end

    it 'returns the created app instance' do
      fake_connection.stub(:get).and_return(fake_response)
      App.stub(:build_from_response).and_return(fake_app)
      result = subject.find_by_id(77)
      expect(result).to eq fake_app
    end

    context 'when status is 404' do
      let(:not_found_response) { double(:not_found_response, status: 404) }

      it 'returns nil' do
        fake_connection.stub(:get).and_return(not_found_response)
        result = subject.find_by_id(3456)
        expect(result).to be_nil
      end
    end
  end

  describe '#all' do
    it 'issues a get request to the proper URL' do
      expect(fake_connection).to receive(:get).with('/apps').and_return(fake_apps_response)
      subject.all
    end

    it 'sends the instantiate_collection message to App' do
      fake_connection.stub(:get).and_return(fake_apps_response)
      expect(App).to receive(:instantiate_collection)
      subject.all
    end

    it 'returns a list of app instances' do
      fake_connection.stub(:get).and_return(fake_apps_response)
      App.stub(:instantiate_collection).and_return([fake_app])
      result = subject.all
      expect(result).to match_array [fake_app]
    end
  end

  describe '#create' do

    it 'posts a json representation of the params' do
      headers_hash = {}
      fake_request.stub(:headers).and_return(headers_hash)
      expect(headers_hash).to receive(:[]=).with("Content-Type", "application/json")
      expect(fake_connection).to receive(:post).and_yield(fake_request).and_return(fake_response)
      expect(fake_request).to receive(:url).with('/apps')
      expect(fake_request).to receive(:body=).with("{\"image\":\"some/image\"}")

      subject.create({image: 'some/image'})
    end

    context 'when successful' do
      let(:fake_faraday_response) do
        double(:fake_faraday_response, {
          success?: true,
          body: '{}'
        })
      end

      before do
        fake_connection.stub(:post).and_return(fake_faraday_response)
      end

      it 'returns a valid app object' do
        app = subject.create({image: 'some/image'})
        expect(app.valid?).to be_true
      end

      it 'includes the application in the response object' do
        app = subject.create({image: 'some/image'})
        expect(app).to eq fake_app
      end
    end
  end
end
