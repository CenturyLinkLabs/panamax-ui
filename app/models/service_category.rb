class ServiceCategory < BaseViewModel

  attr_reader :name, :id

  def self.instantiate_collection(hashes)
    hashes.map do |hash|
      self.new(hash)
    end
  end
end
