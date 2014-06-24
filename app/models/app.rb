require 'kramdown'

class App < BaseResource

  has_many :lite_services, class_name: Service

  schema do
    text :documentation
    text :documentation_to_html
    text :name
    text :from
    text :documentation
  end

  def to_param
    self.id
  end

  def services
    Array(lite_services).map do |service|
      Service.find service.id, params: { app_id: self.id }
    end
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
        groups[Category.new(name: 'Uncategorized')] = uncategorized_services if uncategorized_services.present?
      else
        groups[Category.new(name: 'Services')] = services
      end

      groups
    end

    def services_with_category_name(name)
      services.select { |service| service.categories.any? { |cat| cat.name == name } }
    end

    def uncategorized_services
      services.select { |service| service.categories.blank? }
    end

    def ordered_services
      sorted_categorized_services.concat(uncategorized_services)
    end

    private

    def sorted_categorized_services
      categorized = services.select { |service| service.categories.present? }
      categorized.sort do |a, b|
        a_value = a.category_priority
        b_value = b.category_priority
        (a_value == b_value) ? -1 : a_value - b_value
      end
    end
  end
end
