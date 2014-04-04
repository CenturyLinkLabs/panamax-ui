class Image
  include ActiveModel::Model

  attr_reader :id, :description, :name, :updated_at

  def initialize(attributes)
    @id = attributes['id']
    @description = attributes['description']
    @name = attributes['name']
    @updated_at = attributes['updated_at']
  end
end
