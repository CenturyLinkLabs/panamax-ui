require 'kramdown'

class App < BaseResource
  include MarkdownRenderable
  include Deployable

  before_create :source_image
  before_create :resolve_compose_yaml

  has_many :services

  schema do
    text :documentation
    text :documentation_to_html
    text :name
    text :from
    integer :template_id
  end

  def to_param
    self.id
  end

  def has_empty_env_values?
    services.any? do |service|
      service.has_empty_env_values?
    end
  end

  def service_count_label
    'service'.pluralize(services.length)
  end

  def imagelayers_url
    service_string = ''

    services.each do |service|
      service_string << "#{service.from},"
    end

    "#{IMAGELAYERS_BASE_URL}?images=#{service_string.chop}"
  end

  def find_service_by_name(name)
    services.select do |service|
      service.name == name
    end.first
  end

  concerning :ServiceCategories do
    def categorized_services
      groups = categories.each_with_object({}) do |category, hash|
        hash[category] = services_with_category_name(category.name)
      end

      if groups.present?
        groups[Category.new(name: 'Uncategorized')] = uncategorized_services if uncategorized_services.present?
      else
        groups[Category.new(name: 'Uncategorized')] = services
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
      list.sort_by { |s| s.categories.first.position.to_i }
    end

    def source_image
      if self.attributes[:template_id].blank? && self.attributes[:compose_yaml_file].blank?
        self.attributes[:image] = BaseImage.source(self.attributes[:image], self.attributes.delete(:tag))
      end
    end

    def resolve_compose_yaml
      if self.attributes[:compose_yaml_file].present?
        self.attributes[:compose_yaml] = self.attributes[:compose_yaml_file].read
      end
    end
  end
end
