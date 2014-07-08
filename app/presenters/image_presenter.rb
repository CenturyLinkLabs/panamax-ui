class ImagePresenter
  def initialize(image)
    @image = image
  end

  delegate :description, :status_label, :short_description,
           :star_count, :docker_index_url,
           to: :@image

  def title
    @image.source
  end
end
