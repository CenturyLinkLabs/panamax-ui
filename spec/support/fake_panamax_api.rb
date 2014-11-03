require 'sinatra/base'

class FakePanamaxApi < Sinatra::Base
  get '/search.json' do
    json_response 200, 'search_results.json'
  end

  get '/local_images.json' do
    json_response 200, 'images_representation.json'
  end

  post '/deployment_targets.json' do
    json_response 201, 'deployment_target_representation.json'
  end

  get '/deployment_targets/:id.json' do
    json_response 200, 'deployment_target_representation.json'
  end

  get '/deployment_targets.json' do
    json_response 200, 'deployment_targets_representation.json'
  end

  post '/deployment_targets/:target_id/deployments.json' do
    json_response 201, 'deployment_representation.json'
  end

  get '/registries.json' do
    json_response 200, 'registries_representation.json'
  end

  get '/templates/:id.json' do
    json_response 200, 'template_representation.json'
  end

  post '/templates.json' do
    json_response 201, 'template_representation.json'
  end

  post '/templates/:id/save.json*' do
    json_response 201, 'template_representation.json'
  end

  get '/repositories/:repo/tags' do
    content_type :json
    status 200
    %w(foo bar).to_json
  end

  get '/apps.json' do
    json_response 200, 'app_list_representation.json'
  end

  post '/apps.json' do
    json_response 201, 'app_representation.json'
  end

  get '/apps/:id.:format' do |id, _format|
    json_response 200, 'app_representation.json'
  end

  get '/apps/:app_id/services.json' do
    json_response 200, 'services_representation.json'
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

  put '/apps/:app_id/rebuild.:format' do
    status 204
  end

  put '/apps/:app_id.:format' do
    status 204
  end

  get '/user.json' do
    json_response 200, 'user_representation.json'
  end

  delete '/apps/:app_id/services/:id.?:format' do
    json_response 200, 'service_representation_1.json'
  end

  get '/keywords.json' do
    json_response 200, 'keywords_representation.json'
  end

  get '/types.json' do
    json_response 200, 'types_representation.json'
  end

  get '/template_repos.json' do
    json_response 200, 'template_repos_representation.json'
  end

  post '/template_repos.json' do
    status 201
  end

  delete '/template_repos/1.json' do
    status 200
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end
