require 'active_model'

class TemplateForm
  include ActiveModel::Model

  attr_accessor :repos, :name, :description, :keywords, :types, :documentation
  attr_writer :author, :user, :type

  def author
    @author || @user.try(:email)
  end

  def type
    @type || types.first.name
  end

  def save
    if valid?
      Template.create(
        name: name,
        description: description,
        keywords: keywords,
        authors: [author],
        type: type,
        documentation: documentation
      )
    end
  end
end
