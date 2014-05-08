class BaseViewModel
  def self.attr_reader(*vars)
    @attributes ||= []
    @attributes += vars
    super(*vars)
  end

  def self.attributes
    @attributes
  end

  def initialize(attributes={}, persisted=false)
    attributes.each do |key, val|
      instance_variable_set("@#{key}", val) if self.class.attributes.include?(key.to_sym)
    end
  end

  def eql?(other)
    to_hash.eql?(other.to_hash)
  end

  alias_method :==, :eql?

  def to_hash
    self.class.attributes.each_with_object({}) do |attr, memo|
      memo[attr] = self.send(attr)
    end
  end
end
