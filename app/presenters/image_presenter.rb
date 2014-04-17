class ImagePresenter
  def initialize(image)
    @image = image
  end

  delegate :description, :status_label, :short_description, :star_count, :recommended, to: :image

  def title
    @image.repository
  end

  private

  attr_reader :image
end


