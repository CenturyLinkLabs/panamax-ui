require 'active_resource'

#########
## DiskMap only internally used to rewrite invalid key
## ie the 8:0 key in the example below
## 'disk_map' : {
#    '8:0': {
#    }
#  }
#########
class DiskMap < BaseResource
  include ActiveResource::Singleton

  def find_or_create_resource_for(name)
    name = name.to_s.gsub(':', '_').camelcase.to_sym
    super("z_#{name}")
  end
end

class MachineInfo < BaseResource
  include ActiveResource::Singleton

  self.site = "#{ENV['CADVISOR_PORT']}"

  has_one :disk_map

  def self.singleton_path(_prefix_options={}, _query_options=nil)
    '/api/v1.2/machine'
  end
end
