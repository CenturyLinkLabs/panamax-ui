class Link
  attr_reader :service_name

  def initialize(attributes={})
    @service_name = attributes['service_name']
  end

  def self.instantiate_collection(hashes)
    if hashes.present?
      hashes.map do |hash|
        self.new(hash)
      end
    end
  end
end
