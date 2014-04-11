require 'sinatra/base'

class FakePanamaxApi < Sinatra::Base
  get '/search' do
    json_response 200, 'search_results.json'
  end

  post '/apps' do
    json_response 200, 'search_results.json' #todo change this to something else
  end

  private

  def json_response(response_code, file_name)
    content_type :json
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end
end
