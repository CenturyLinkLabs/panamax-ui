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
    create_with_sub_resources(attributes)
  end

  def self.create_with_sub_resources(attributes)
    attributes['services'] = attributes['services'].map{ |service_hash| Service.create_with_sub_resources(service_hash) }
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
      services.inject([]) do |array, service|
        service.categories.each do |category|
          array << category unless array.any?{ |cat| cat.name == category.name }
        end
        array
      end
    end

    def categorized_services
      groups = service_categories.inject({}) do |hash, category|
        hash[category.name] = services_with_category_name(category.name)
        hash
      end
      return groups
    end

    def services_with_category_name(name)
      services.select { |service| service.categories.any?{ |cat| cat.name == name } }
    end

    def uncategorized_services
      services.select { |service| service.categories.blank? }
    end
  end


  private

  def add_errors(errors_hash)
    (errors_hash || {}).each do |k,v|
      errors.add(k,v)
    end
  end
end
