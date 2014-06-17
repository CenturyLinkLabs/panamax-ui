require 'sinatra/base'

class FakePanamaxApi < Sinatra::Base
  get '/search.json' do
    json_response 200, 'search_results.json'
  end

  post '/templates.json' do
    json_response 201, 'template_representation.json'
  end

  get '/repositories/:repo/tags' do
    content_type :json
    status 200
    %w(foo bar).to_json
  end

  get '/apps' do
    json_response 200, 'app_list_representation.json'
  end

  post '/apps' do
    json_response 200, 'app_representation.json'
  end

  get '/apps/:id' do
    json_response 200, 'app_representation.json'
  end

  get '/apps/:app_id/services/:id.?:format' do |_app_id, id, _format|
    json_response 200, "service_representation_#{id}.json"
  end

  get '/apps/:app_id/categories/:id.?:format' do |_app_id, id, _format|
    categories = [
      { 'id' => '1', 'name' => 'foo' },
      { 'id' => '2', 'name' => 'baz' },
      { 'id' => '3', 'name' => 'bar' },
      { 'id' => '4', 'name' => 'Web Tier' }
    ]
    content_type :json
    status 200
    categories.find { |cat| cat['id'] == id.to_s }.to_json
  end

  put '/apps/:app_id/services/:id' do
    status 204
  end

  get '/user.json' do
    json_response 200, 'user_representation.json'
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end
