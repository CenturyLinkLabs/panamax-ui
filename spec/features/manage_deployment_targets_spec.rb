require 'spec_helper'

describe 'managing deployment targets' do
  context 'as a user' do
    it 'can view a list of deployment targets' do
      visit '/deployment_targets'

      expect(page).to have_content 'Remote Deployment Targets'
      expect(page).to have_content 'Socialize staging environment'
      expect(page).to have_content 'Endpoint: https://foo.host'
      expect(page).to have_content 'Target Token aHR0cHM6Ly8xMC4wLjEuODozMDAxfGEyNjNkNWEyLTVkNDUtNGUxNy1iNDQ3LTQ2MGM3YzcwODIy'
    end

    it 'can create a deployment target' do
      visit '/deployment_targets'

      fill_in 'Name', with: 'Socialize Production Environment'
      fill_in 'Token', with: 'gobbleydeegook'

      click_on 'Create Remote Deployment Target'

      expect(page).to have_content 'Your deployment target was added successfully'
    end
  end
end
