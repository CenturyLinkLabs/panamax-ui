require 'active_model'

class Service
  include ActiveModel::Model

  attr_reader :name, :id

  def initialize(attributes={})
    @name = attributes['name']
    @id = attributes['id']
  end

  def to_param
    id
  end

  def self.create_from_response(response)
    attributes = JSON.parse(response)
    self.new(attributes)
  end

end
