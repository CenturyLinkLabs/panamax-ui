require 'active_model'

class App
  include ActiveModel::Model

  attr_reader :name, :id

  def initialize(attributes={})
    add_errors(attributes['errors'])
    @name = attributes['name']
    @id = attributes['id']
  end

  def self.create_from_response(response)
    attributes = JSON.parse(response)
    self.new(attributes)
  end

  def to_param
    id
  end

  def valid?
    errors.empty?
  end

  private

  def add_errors(errors_hash)
    (errors_hash || {}).each do |k,v|
      errors.add(k,v)
    end
  end
end
