class TemplatePresenter
  attr_reader :title, :description, :updated_at, :status_label, :short_description

  def initialize(template)
    @title = template.name
    @description = template.description
    @short_description = template.short_description
    @updated_at = template.updated_at
    @status_label = 'Template'
  end
end


