CtlBaseUi.configure do |config|
  config.additional_entries = [
    'panamax_buttons',
    'panamax_forms',
    'panamax_expandable',
    'breadcrumbs',
    'search',
    'service_details',
    'service_journal',
    'blog_feed',
    'finger_tabs'
  ]

  config.view_helpers = [
    PanamaxUi::BreadcrumbHelper
  ]

  config.partials_path = '/styleguide/'
  config.app_name = 'Panamax'
  config.additional_stylesheets = ['application', 'styleguide']
end
