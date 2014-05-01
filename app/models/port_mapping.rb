class PortMapping
  attr_reader :host_port, :container_port

  def initialize(attributes={})
    @host_port = attributes['host_port']
    @container_port = attributes['container_port']
  end

  def self.new_from_collection(hashes)
    if hashes.present?
      hashes.map do |hash|
        self.new(hash)
      end
    end
  end
end
