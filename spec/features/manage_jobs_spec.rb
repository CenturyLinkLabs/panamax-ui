require 'spec_helper'

describe 'managing jobs' do
  context 'as a user' do
    it 'can create a job' do
      visit '/deployment_targets'

      click_on 'Amazon Web Services'

      fill_in 'REMOTE_TARGET_NAME', with: 'foo'
      fill_in 'CLIENT_ID', with: 'bar'

      click_on 'Add New Target'

      page.should have_content 'Add Another Remote Deployment Target'

    end
  end
end
