class Repository < BaseResource

  schema do
    string :id
  end

  def image_tags
    self.try(:tags) || []
  end
end
