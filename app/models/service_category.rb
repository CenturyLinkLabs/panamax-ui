class ServiceCategory

  attr_reader :name, :id

  def initialize(attributes={})
    @name = attributes['name']
    @id = attributes['id']
  end

  def self.instantiate_collection(hashes)
    hashes.map do |hash|
      self.new(hash)
    end
  end
end
