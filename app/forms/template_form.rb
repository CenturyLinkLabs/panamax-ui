require 'active_model'

class TemplateForm
  include ActiveModel::Model

  attr_accessor :repos, :name, :description

  def save
    if valid?
      Template.create(name: name, description: description)
    end
  end
end
