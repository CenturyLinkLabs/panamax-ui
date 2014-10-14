require 'active_resource'

class MachineInfo < BaseResource
  include ActiveResource::Singleton

  self.site = "#{ENV['CADVISOR_PORT']}"

  def self.singleton_path(_prefix_options={}, _query_options=nil)
    '/api/v1.0/machine'
  end
end
