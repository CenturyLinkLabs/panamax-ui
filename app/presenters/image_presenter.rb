class ImagePresenter
  attr_reader :title, :description, :status_label, :short_description, :star_count

  def initialize(image)
    @title = image.repository
    @description = image.description
    @short_description = image.short_description
    @status_label = image.status_label
    @star_count = image.star_count
  end
end


