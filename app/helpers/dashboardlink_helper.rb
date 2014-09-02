module DashboardlinkHelper
  def dashboard_link_for(resourceName, item)
    case resourceName
      when "Application"
        link_to item.name, app_path(item.id)
      when "Source"
        link_to item.name, item.uri, target: '_blank'
      else
        item.name
    end
  end
end