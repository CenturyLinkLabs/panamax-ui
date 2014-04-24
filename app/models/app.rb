require 'active_model'

class App
  include ActiveModel::Model

  attr_reader :name, :id, :services

  def initialize(attributes={})
    add_errors(attributes['errors'])
    @name = attributes['name']
    @id = attributes['id']
    @services = attributes['services']
  end

  def self.create_from_response(response)
    attributes = JSON.parse(response)
    self.new(attributes)
  end

  def to_param
    id
  end

  def valid?
    errors.empty?
  end

  concerning :ServiceCategories do
    def service_categories
      Set.new(services.map{ |service| service['categories'] }.flatten.compact)
    end
  end

  def categorized_services
    groups = {}
    service_categories.each do |category|
      groups[category['name']] = services_with_category_name(category['name'])
    end
    return groups
  end

  def services_with_category_name(name)
    services.select { |service| service['categories'].any?{ |cat| cat['name'] == name } }
  end

  private

  def add_errors(errors_hash)
    (errors_hash || {}).each do |k,v|
      errors.add(k,v)
    end
  end
end
