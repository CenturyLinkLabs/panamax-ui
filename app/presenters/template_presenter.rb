class TemplatePresenter
  def initialize(template)
    @template = template
  end

  delegate :id, :description, :last_updated_on, :short_description,
           :image_count, :image_count_label, :recommended_class,
           :icon_src,
           to: :@template

  def title
    @template.name
  end

  def status_label
    'Template'
  end
end


