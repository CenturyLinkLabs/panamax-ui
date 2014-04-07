class ImagePresenter
  attr_reader :name, :description, :updated_at, :status_label

  def initialize(image)
    @name = image.name
    @description = image.description
    @updated_at = image.updated_at
    @status_label = image.status_label
  end
end


