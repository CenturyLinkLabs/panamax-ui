require 'active_model'

class TemplateForm
  include ActiveModel::Model

  attr_accessor :repos, :name, :description, :keywords
  attr_writer :author, :user

  def author
    @author || @user.try(:email)
  end

  def save
    if valid?
      Template.create(
        name: name,
        description: description,
        keywords: keywords,
        authors: [author]
      )
    end
  end
end
