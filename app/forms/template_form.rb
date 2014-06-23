require 'active_model'

class TemplateForm
  include ActiveModel::Model

  attr_accessor :repos, :name, :description, :keywords

  def save
    if valid?
      Template.create(
        name: name,
        description: description,
        keywords: keywords
      )
    end
  end
end
