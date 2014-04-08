class TemplatePresenter
  attr_reader :title, :description, :updated_at, :status_label

  def initialize(template)
    @title = template.name
    @description = template.description
    @updated_at = template.updated_at
    @status_label = 'Template'
  end
end


