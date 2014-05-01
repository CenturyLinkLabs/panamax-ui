require 'active_model'

class Service
  include ActiveModel::Model

  attr_reader :name, :id, :categories, :ports

  def initialize(attributes={})
    @name = attributes['name']
    @id = attributes['id']
    @categories = attributes['categories']
    @ports = attributes['ports']
  end

  def category_names
    categories.map(&:name)
  end

  def to_param
    id
  end

  def self.create_from_response(response)
    attributes = JSON.parse(response)
    create_with_sub_resources(attributes)
  end

  def self.create_with_sub_resources(attributes)
    attributes['categories'] = attributes['categories'].map{ |category_hash| ServiceCategory.new(category_hash)  }
    attributes['ports'] = (attributes['ports'] || []).map{ |ports_hash| PortMapping.new(ports_hash)  }
    self.new(attributes)
  end

end
