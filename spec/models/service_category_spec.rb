require 'spec_helper'

describe ServiceCategory do
  it_behaves_like 'a view model', {
    'name' => 'App Tier',
    'id' => 77
  }

  it_behaves_like 'a collection builder', [
    {'name' => 'App tier'},
    {'name' => 'DB tier'}
  ]
end
