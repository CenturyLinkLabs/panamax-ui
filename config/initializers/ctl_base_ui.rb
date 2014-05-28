CtlBaseUi.configure do |config|
  config.additional_entries = [
    'panamax_buttons',
    'panamax_forms',
    'breadcrumbs',
    'search',
    'service_details',
    'service_journal'
  ]

  config.view_helpers = [
    PanamaxUi::BreadcrumbHelper
  ]

  config.partials_path = '/styleguide/'
  config.app_name = 'Panamax'
  config.additional_stylesheets = ['application']
end
