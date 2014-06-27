require 'spec_helper'

describe ApplicationUrlHelper do
  describe '#app_url_for' do
    it 'returns service name: "App" and port: [8666] for Wordpress' do
      subject = app_url_for(App.new(from: 'Wordpress', id: 99, name: 'App'))
      expect(subject.keys).to match_array ['App']
      expect(subject.values).to match_array [['8666']]
    end

    it 'returns service name: "App" and port: [8667] for Rails' do
      subject = app_url_for(App.new(from: 'Rails', id: 99, name: 'App'))
      expect(subject.keys).to match_array ['App']
      expect(subject.values).to match_array [['8667']]
    end

    it 'returns default application host ports' do
      app = App.new(from: 'Nowhere', id: 99, name: 'App', services: [])
      app.should_receive(:host_ports)
      app_url_for(app)
    end
  end

  describe '#category_show_or_index_path' do
    it 'links to the cateries index path when no category id is supplied' do
      expect(category_show_or_index_path(2, nil)).to eq app_categories_path(2)
    end

    it 'links to the cateries show path when a category id is supplied' do
      expect(category_show_or_index_path(2, 5)).to eq app_category_path(2, 5)
    end
  end
end
