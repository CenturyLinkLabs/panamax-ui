class DockerStatus < Hash

  def initialize(attrs, _=nil)
    self.merge!(attrs)
  end
end
