require 'active_model'

class TemplateForm
  include ActiveModel::Model

  attr_accessor :repos, :name

  def save
    if valid?
      Template.create(name: name)
    end
  end
end
