module ApplicationUrlHelper
  def app_url_for(app)
    # TODO: This is a static hack for demo purpose
    if app.from.include? 'Rails'
      { 'App' => ['8667'] }
    elsif app.from.include? 'Wordpress'
      { 'App' => ['8666'] }
    else
      app.host_ports
    end
  end

  def category_show_or_index_path(app_id, category_id)
    if category_id.present?
      app_category_path(app_id, category_id)
    else
      app_categories_path(app_id)
    end
  end
end
