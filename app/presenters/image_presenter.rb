class ImagePresenter
  attr_reader :title, :description, :status_label, :short_description

  def initialize(image)
    @title = image.repository
    @description = image.description
    @short_description = image.short_description
    @status_label = image.status_label
  end
end


