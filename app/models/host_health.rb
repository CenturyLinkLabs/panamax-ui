require 'active_resource'

class HostHealth < BaseResource
  include ActiveResource::Singleton
  include CadvisorMeasurable

  self.site = "#{ENV['CADVISOR_PORT']}"
  def self.singleton_path(_prefix_options={}, _query_options=nil)
    '/api/v1.2/containers/'
  end


end
