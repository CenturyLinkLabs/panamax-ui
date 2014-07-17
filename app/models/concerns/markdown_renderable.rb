module MarkdownRenderable
  extend ActiveSupport::Concern

  def documentation_to_html
    Kramdown::Document.new(self.documentation).to_html if self.documentation.present?
  end

end
