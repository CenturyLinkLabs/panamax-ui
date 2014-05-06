require 'active_resource'

class BaseResource < ActiveResource::Base
  self.site = PanamaxApi::URL
end
