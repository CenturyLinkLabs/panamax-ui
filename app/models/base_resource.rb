require 'active_resource'

class BaseResource < ActiveResource::Base

  DOCKER_INDEX_BASE_URL = 'https://registry.hub.docker.com/'

  self.site = PanamaxApi::URL

  def self.all_with_response(options={})
    prefix_options, query_options = split_options(options[:params])
    path = collection_path(prefix_options, query_options)
    response = connection.get(path, headers)
    collection = instantiate_collection((format.decode(response.body) || []), query_options, prefix_options)
    wrap_collection_with_response(collection, response)
  end

  def self.wrap_collection_with_response(collection, response)
    wrapped = SimpleDelegator.new(collection)
    wrapped.instance_variable_set(:@response, response)
    wrapped.singleton_class.send(:define_method, 'response') do
      @response
    end
    wrapped
  end
  private_class_method :wrap_collection_with_response

  def write_attributes(attributes)
    attributes.each do |key, val|
      setter = "#{key}="
      self.public_send(setter, val) if self.respond_to?(setter)
    end
  end

  def self.find_by_id(id)
    self.find(id)
  rescue ActiveResource::ResourceNotFound
    nil
  end

  def _deleted
    false
  end
end
