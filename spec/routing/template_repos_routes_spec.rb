require 'spec_helper'

describe 'template repos routes' do

  it 'routes GET template repos to template repos index' do
    expect(get: '/template_repos').to route_to(controller: 'template_repos', action: 'index')
  end
end
