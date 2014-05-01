class PortMapping
  attr_reader :host_port, :container_port

  def initialize(attributes={})
    @host_port = attributes['host_port']
    @container_port = attributes['container_port']
  end
end
