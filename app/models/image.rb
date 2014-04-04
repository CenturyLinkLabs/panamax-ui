class Image
  include ActiveModel::Model

  attr_reader :id, :description, :name

  def initialize(attributes)
    @id = attributes['id']
    @description = attributes['description']
    @name = attributes['name']
  end
end
