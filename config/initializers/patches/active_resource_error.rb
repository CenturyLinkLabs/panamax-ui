require 'active_resource/exceptions'
require 'json'

module ActiveResource
  class ConnectionError < StandardError

    attr_reader :message

    def initialize(response, message=nil)
      @response = response
      @message = JSON.parse(response.try(:body))['message']
    rescue
      @message = message
    end

  end
end
