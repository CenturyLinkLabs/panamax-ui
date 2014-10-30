require 'spec_helper'

describe 'the ctl base ui styleguid' do
  it 'works' do
    visit '/ctl-base-ui/styleguide'

    expect(page).to have_content 'Panamax specific components'
  end
end
