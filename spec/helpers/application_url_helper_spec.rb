require 'spec_helper'

describe ApplicationUrlHelper do
  describe '#application_url_for' do
    it 'returns service name: "App" and port: [8666] for Wordpress' do
      subject = application_url_for(App.new(from: 'Wordpress', id: 99, name: 'App'))
      expect(subject.keys).to match_array ['App']
      expect(subject.values).to match_array [['8666']]
    end

    it 'returns service name: "App" and port: [8667] for Rails' do
      subject = application_url_for(App.new(from: 'Rails', id: 99, name: 'App'))
      expect(subject.keys).to match_array ['App']
      expect(subject.values).to match_array [['8667']]
    end

    it 'returns default application host ports' do
      app = App.new(from: 'Nowhere', id: 99, name: 'App', services: [])
      app.should_receive(:host_ports)
      application_url_for(app)
    end
  end
end
