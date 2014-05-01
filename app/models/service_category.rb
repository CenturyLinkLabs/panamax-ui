class ServiceCategory

  attr_reader :name, :id

  def initialize(attributes={})
    @name = attributes['name']
    @id = attributes['id']
  end

end