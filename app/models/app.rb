require 'kramdown'

class App < BaseResource
  before_create :source_image,
    unless: -> { self.attributes[:template_id].present? }

  has_many :services

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

  def self.find_by_id(id)
    self.find(id)
  rescue ActiveResource::ResourceNotFound
    nil
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
      sort_by_position services.select { |service| service.categories.any? { |cat| cat.name == name } }
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

    def sort_by_position(list)
      list.sort_by { |s| s.categories.first.position }
    end

    def source_image
      self.attributes[:image] =
        BaseImage.source(self.attributes[:image], self.attributes.delete(:tag))
    end
  end
end
