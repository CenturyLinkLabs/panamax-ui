module ApplicationHelper
  def icon_source_for(type)
    ActionController::Base.helpers.asset_path("type_icons/#{type.downcase.gsub(/\s/, '_')}.svg")
  end

  def metrics_url
    "http://#{request.host}:3002/"
  end

  def metrics_url_for(name)
    "http://#{request.host}:3002/docker/#{name}"
  end

  def none_if(condition)
    'none' if condition
  end

  def formatted_title(*page_titles)
    titles = ['Panamax'] + page_titles
    titles.compact.join(' > ')
  end

  def markdown_to_html(markdown)
    markdown.present? ? Kramdown::Document.new(markdown).to_html : ''
  end
end
