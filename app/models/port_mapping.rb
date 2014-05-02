class PortMapping < BaseViewModel
  attr_reader :host_port, :container_port

  def self.instantiate_collection(hashes)
    if hashes.present?
      hashes.map do |hash|
        self.new(hash)
      end
    end
  end
end
