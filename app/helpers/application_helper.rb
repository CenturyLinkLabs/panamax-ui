module ApplicationHelper
  def icon_source_for(type)
    ActionController::Base.helpers.asset_path("type_icons/#{type.downcase.gsub(/\s/, '_')}.svg")
  end

  def metrics_url
    "http://#{request.host}:3002/"
  end

  def metrics_url_for(name)
    "http://#{request.host}:3002/containers/docker/#{name}"
  end
end
