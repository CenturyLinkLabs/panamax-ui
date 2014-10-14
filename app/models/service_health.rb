require 'active_resource'

class ServiceHealth < BaseResource
  include CadvisorMeasurable

  self.site = "#{ENV['CADVISOR_PORT']}"

  self.collection_name = 'docker'
  self.element_name = 'docker'
  self.prefix = '/api/v1.0/containers/'
  self.include_format_in_path = false
end
