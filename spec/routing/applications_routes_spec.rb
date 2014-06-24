require 'spec_helper'

describe 'applications routes' do

  it 'routes GET journal to the apps controller journal action' do
    expect(get: '/apps/1/journal').to route_to(
      controller: 'apps',
      action: 'journal',
      id: '1'
    )
  end

  it 'routes PUT rebuild to the apps controller rebuild action' do
    expect(put: '/apps/1/rebuild').to route_to(
      controller: 'apps',
      action: 'rebuild',
      id: '1'
    )
  end
end
