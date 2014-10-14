module ApplicationHelper
  def icon_source_for(type)
    ActionController::Base.helpers.asset_path("type_icons/#{type.downcase.gsub(/\s/, '_')}.svg")
  end

  def metrics_url
    HostHealth.site
  end

  def metrics_url_for(name)
    "#{HostHealth.site}containers/docker/#{name}"
  end
end
