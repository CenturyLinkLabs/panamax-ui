module ApplicationHelper
  def icon_source_for(type)
    ActionController::Base.helpers.asset_path("type_icons/#{type.downcase.gsub(/\s/, '_')}.svg")
  end
end
