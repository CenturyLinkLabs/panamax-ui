CtlBaseUi.configure do |config|
  config.additional_entries = [
    'search',
    'breadcrumbs'
  ]

  config.view_helpers = [
    PanamaxUi::BreadcrumbHelper
  ]

  config.partials_path = '/styleguide/'
  config.app_name = 'Panamax'
  config.additional_stylesheets = ['application']
end
