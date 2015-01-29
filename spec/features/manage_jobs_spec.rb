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

      page.should have_content 'C3DC7DE3-F51C-67E3-21A3-4B3EE084DBF7'

      page.should have_content 'Deploy CenturyLink Cloud Cluster'
      page.should have_content 'Install Kubernetes on Cluster'
      page.should have_content 'Deploy Panamax Remote Agent Node'
      page.should have_content 'Install Panamax Remote Agent, Adaptor and Remote Target Endpoint'

    end
  end
end
