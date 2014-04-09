class ImagePresenter
  attr_reader :title, :description, :status_label

  def initialize(image)
    @title = image.repository
    @description = image.description
    @status_label = image.status_label
  end
end


