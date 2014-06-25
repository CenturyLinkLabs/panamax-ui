require 'spec_helper'

describe 'applications routes' do

  it 'routes GET journal to the applications controller journal action' do
    expect(get: '/apps/1/journal').to route_to(
      controller: 'apps',
      action: 'journal',
      id: '1'
    )
  end
end
