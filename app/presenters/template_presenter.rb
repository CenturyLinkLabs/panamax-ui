class TemplatePresenter
  def initialize(template)
    @template = template
  end

  delegate :description, :updated_at, :short_description, to: :template

  def title
    template.name
  end

  def status_label
    'Template'
  end

  private

  attr_reader :template
end


