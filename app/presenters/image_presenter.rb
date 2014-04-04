class ImagePresenter
  attr_reader :name, :description, :updated_at

  def initialize(image)
    @name = image.name
    @description = image.description
    @updated_at = image.updated_at
  end
end


