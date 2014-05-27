require 'spec_helper'

describe 'applications routes' do

  it 'routes GET journal to the applications controller journal action' do
    expect(get: '/applications/1/journal').to route_to(
      controller: 'applications',
      action: 'journal',
      id: '1'
    )
  end
end
