class ImagePresenter
  attr_reader :title, :description, :updated_at, :status_label

  def initialize(image)
    @title = image.repository
    @description = image.description
    @updated_at = image.updated_at
    @status_label = image.status_label
  end
end


