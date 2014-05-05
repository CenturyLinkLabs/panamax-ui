require 'spec_helper'

describe PortMapping do
  it_behaves_like 'a view model', {
    'host_port' => 8080,
    'container_port' => 80
  }

  it_behaves_like 'a collection builder', [
    { 'host_port' => 8080, 'container_port' => 80 },
    { 'host_port' => 7070, 'container_port' => 82 }
  ]
end
