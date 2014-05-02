class Link < BaseViewModel
  attr_reader :service_name

  def self.instantiate_collection(hashes)
    if hashes.present?
      hashes.map do |hash|
        self.new(hash)
      end
    end
  end
end
