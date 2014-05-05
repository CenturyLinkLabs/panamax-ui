class PortMapping < BaseViewModel
  include CollectionBuilder

  attr_reader :host_port, :container_port
end
