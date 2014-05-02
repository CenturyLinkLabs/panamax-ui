require 'active_model'

class App < BaseViewModel
  include ActiveModel::Validations

  attr_reader :name, :id, :services

  def initialize(attributes={})
    super
    add_errors(attributes['errors'])
  end

  def self.build_from_response(response)
    attributes = JSON.parse(response)
    build_with_sub_resources(attributes)
  end

  def self.build_with_sub_resources(attributes)
    attributes['services'] = attributes['services'].map{ |service_hash| Service.build_with_sub_resources(service_hash) }
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
      services.each_with_object([]) do |service, array|
        service.categories.each do |category|
          array << category unless array.any?{ |cat| cat.name == category.name }
        end
      end
    end

    def categorized_services
      groups = service_categories.each_with_object({}) do |category, hash|
        hash[category.name] = services_with_category_name(category.name)
      end

      if groups.present?
        groups = groups.merge('Uncategorized' => uncategorized_services) if uncategorized_services.present?
      else
        groups['Services'] = services
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
