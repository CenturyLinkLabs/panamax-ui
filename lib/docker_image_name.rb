class DockerImageName
  def initialize(source)
    @source = source
  end

  def self.parse(source)
    self.new(source)
  end

  def base_image
    @source.rpartition(':').reject(&:empty?).first
  end

  def tag
    parts = @source.split(':')
    parts.last if parts.length > 1
  end
end
