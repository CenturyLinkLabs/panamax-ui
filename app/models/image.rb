class Image
  include ActiveModel::Model

  attr_reader :id, :description, :name

  def initialize(attributes)
    info = attributes['info']
    @id = attributes['id']
    @description = info['description']
    @name = info['name']
  end
end
