require 'active_model'
require 'kramdown'

class App < BaseViewModel
  include CollectionBuilder
  include ActiveModel::Validations

  def self.model_name
    ActiveModel::Name.new(self, nil, 'Application')
  end

  attr_reader :name, :id, :services, :categories, :documentation

  def initialize(attributes={}, persisted=false)
    super(attributes)
    add_errors(attributes['errors'])
  end

  def self.build_from_response(response)
    attributes = JSON.parse(response)
    build_with_sub_resources(attributes)
  end

  def self.build_with_sub_resources(attributes)
    attributes['services'].map! do |service_hash|
      Service.find(service_hash['id'], params: {app_id: attributes['id']})
    end
    attributes['categories'] = AppCategory.instantiate_collection(attributes['categories'])
    self.new(attributes)
  end

  def to_param
    id
  end

  def valid?
    errors.empty?
  end

  def service_count_label
    'Service'.pluralize(services.length)
  end

  def documentation_to_html
    Kramdown::Document.new(self.documentation).to_html if self.documentation.present?
  end

  def host_ports
    running_services.each_with_object({}) do |service, hash|
      ports = service.ports.map { |port_binding| port_binding.host_port }.flatten.compact
      hash[service.name] = ports unless ports.empty?
    end
  end

  def running_services
    services.select(&:running?)
  end

  concerning :ServiceCategories do
    def categorized_services
      groups = categories.each_with_object({}) do |category, hash|
        hash[category] = services_with_category_name(category.name)
      end

      if groups.present?
        groups[AppCategory.new({name: 'Uncategorized'})] = uncategorized_services if uncategorized_services.present?
      else
        groups[AppCategory.new({name: 'Services'})] = services
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
