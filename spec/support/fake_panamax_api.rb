require 'sinatra/base'

class FakePanamaxApi < Sinatra::Base
  get '/search' do
    json_response 200, 'search_results.json'
  end

  post '/apps' do
    json_response 200, 'app_representation.json'
  end

  get "/apps/:id" do
    json_response 200, 'app_representation.json'
  end

  get "/apps/:app_id/services/:id" do
    json_response 200, 'service_representation.json'
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end
