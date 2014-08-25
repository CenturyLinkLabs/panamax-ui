module MarkdownRenderable
  extend ActiveSupport::Concern

  def documentation_to_html
    self.documentation.present? ? Kramdown::Document.new(self.documentation).to_html : ''
  end

end
