require 'active_model'

class Service
  include ActiveModel::Model

  attr_reader :name, :id, :categories

  def initialize(attributes={})
    @name = attributes['name']
    @id = attributes['id']
    @categories = attributes['categories']
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
    self.new(attributes)
  end

end
