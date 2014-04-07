class TemplatePresenter
  attr_reader :title, :description, :updated_at

  def initialize(template)
    @title = template.name
    @description = template.description
    @updated_at = template.updated_at
  end
end


