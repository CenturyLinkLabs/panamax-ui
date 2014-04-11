class TemplatePresenter
  def initialize(template)
    @template = template
  end

  delegate :id, :description, :updated_at, :short_description, :image_count, :image_count_label, to: :template

  def title
    template.name
  end

  def status_label
    'Template'
  end

  private

  attr_reader :template
end


