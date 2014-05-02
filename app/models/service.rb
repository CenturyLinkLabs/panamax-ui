require 'active_model'

class Service
  include ActiveModel::Model

  attr_reader :name, :id, :categories, :ports, :links, :environment

  def initialize(attributes={})
    @name = attributes['name']
    @id = attributes['id']
    @categories = attributes['categories']
    @ports = attributes['ports']
    @environment = attributes['environment']
    @links = attributes['links']
  end

  def category_names
    categories.map(&:name)
  end

  def to_param
    id
  end

  def self.build_from_response(response)
    attributes = JSON.parse(response)
    build_with_sub_resources(attributes)
  end

  private

  def self.build_with_sub_resources(attributes)
    attributes['categories'] = ServiceCategory.instantiate_collection(attributes['categories'])
    attributes['ports'] = PortMapping.instantiate_collection(attributes['ports'])
    attributes['environment'] = EnvironmentVariable.instantiate_collection(attributes['environment'])
    attributes['links'] = Link.instantiate_collection(attributes['links'])
    self.new(attributes)
  end

end
