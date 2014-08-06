class LocalImage < BaseImage
  def local?
    true
  end

  def name
    tags.first
  end
end
