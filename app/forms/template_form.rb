require 'active_model'

class TemplateForm
  include ActiveModel::Model

  attr_accessor :repos, :name
end
