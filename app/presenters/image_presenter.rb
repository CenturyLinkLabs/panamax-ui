class ImagePresenter
  attr_reader :title, :description, :updated_at

  def initialize(image)
    @title = image.repository
    @description = image.description
    @updated_at = image.updated_at
  end
end


