require 'spec_helper'

describe Link do
  it_behaves_like 'a view model', {
    'service_name' => 'DB'
  }
  it_behaves_like 'a collection builder', [
    { 'service_name' => 'foo'},
    { 'service_name' => 'bar'}
  ]

end
