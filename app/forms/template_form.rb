require 'active_model'

class TemplateForm
  include ActiveModel::Model

  attr_accessor :repo, :name, :description, :keywords, :types, :app, :user
  attr_writer :author, :type, :documentation, :app_id

  def author
    @author || @user.try(:email)
  end

  def type
    @type || types.first.name
  end

  def app_id
    @app_id || @app.try(:id)
  end

  def documentation
    doc = @documentation || @app.try(:documentation)
    doc.gsub(/\r/, '') if doc
  end

  def save
    @template = create_template
    if @template.valid?
      save_template_to_repo(@template)
    else
      self.errors.messages.merge!(@template.errors.messages)
      return false
    end
  end

  private

  def create_template
    Template.create(
      name: name,
      description: description,
      keywords: keywords,
      authors: [author],
      type: type,
      app_id: app_id,
      documentation: documentation
    )
  end

  def save_template_to_repo(template)
    body = {
      repo: repo,
      file_name: name.downcase.gsub(/\s/, '_')
    }
    template.post(:save, body)
  end

end
