class ImagePresenter

  def initialize(image, view_context)
    @image = image
    @view_context = view_context
  end

  delegate :description, :status_label, :badge_class, :short_description,
           :star_count, :docker_index_url, :imagelayers_url, :registry_id,
           to: :@image

  def title
    @image.source
  end

  def tag_options
    @view_context.options_for_select(@image.tags)
  end
end
