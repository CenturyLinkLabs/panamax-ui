require 'spec_helper'

describe ApplicationsService do
  let(:fake_connection) { double(:fake_connection) }
  let(:fake_req) { double(:fake_request) }

  describe '#create' do
    subject {
      ApplicationsService.new(fake_connection)
    }

    it 'posts a json representation of the params' do
      headers_hash = {}
      fake_req.stub(:headers).and_return(headers_hash)
      expect(headers_hash).to receive(:[]=).with("Content-Type", "application/json")
      expect(fake_connection).to receive(:post).and_yield(fake_req)
      expect(fake_req).to receive(:url).with('/apps')
      expect(fake_req).to receive(:body=).with("{\"image\":\"some/image\"}")

      subject.create({image: 'some/image'})
    end
  end
end
