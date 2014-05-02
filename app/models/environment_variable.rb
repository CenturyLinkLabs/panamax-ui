class EnvironmentVariable

  attr_reader :name, :value

  def initialize(attributes={})
    @name = attributes['name']
    @value = attributes['value']
  end

  def self.instantiate_collection(hash)
    if hash.present?
      hash.map do |name, value|
        self.new('name' => name, 'value' => value)
      end
    end
  end
end
