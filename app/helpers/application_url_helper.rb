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
end
