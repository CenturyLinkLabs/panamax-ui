class Image
  include ActiveModel::Model

  attr_reader :id, :description, :repository, :updated_at

  def initialize(attributes)
    @id = attributes['id']
    @description = attributes['description']
    @repository = attributes['repository']
    @updated_at = attributes['updated_at']
  end
end
