class Repository < BaseResource

  schema do
    string :id
  end

  def image_tags
    self.respond_to?(:tags) ? tags : []
  end
end
