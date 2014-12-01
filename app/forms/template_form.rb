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
    # doc = default_documentation if doc.blank?

    # The regex here may require some explanation. Any trailing whitespace on
    # a line in the documentation causes problems for our YAML template
    # serialization since YAML has no way to represent trailing whitespace
    # (it resorts to displaying the text as one, single-line string with
    # embedded escape characters). The regex strips out any trailing whitespace
    # that precedes a newline. Of course it gets a bit dicey because the newline
    # character is itself whitespace. To prevent the regex from greedily
    # swallowing up consecutive newline chars we need to search for occurrences
    # of non-newline-whitespace which precedes a newline. The [^\S\n] group
    # uses the double-negative trick to get whitespace excluding newlines.
    doc.gsub(/[^\S\n]*(?=\n)/, '') if doc
  end

  def save
    @template = create_template
    if @template.valid?
      begin
        save_template_to_repo(@template)
      rescue => ex
        self.errors.add(:repo, ex.message)
        return false
      end
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
      documentation: documentation,
      source: repo
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
