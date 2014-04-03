class ImagePresenter
  attr_reader :name, :description

  def initialize(image)
    @name = image.name
    @description = image.description
  end
end


