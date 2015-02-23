require 'spec_helper'

describe 'managing jobs' do
  context 'as a user' do
    it 'can create a job' do
      visit '/deployment_targets'

      click_on 'Amazon Web Services'

      fill_in 'REMOTE_TARGET_NAME', with: 'foo'
      fill_in 'CLIENT_ID', with: 'bar'

      click_on 'Add New Target'

      expect(page).to have_content 'Add a Remote Deployment Target'

      expect(page).to have_content 'Amazon Web Services'

      expect(page).to have_content 'Deploy CenturyLink Cloud Cluster'
      expect(page).to have_content 'Install Kubernetes on Cluster'
      expect(page).to have_content 'Deploy Panamax Remote Agent Node'
      expect(page).to have_content 'Install Panamax Remote Agent, Adaptor and Remote Target Endpoint'

    end
  end
end
