require 'spec_helper'

describe 'managing deployment targets' do
  context 'as a user' do
    it 'can view a list of deployment targets' do
      visit '/deployment_targets'

      expect(page).to have_content 'Remote Deployment Targets'

      within('div', text: 'Socialize') do
        expect(page).to have_content 'Socialize staging environment'
        expect(page).to have_content 'Endpoint: https://foo.host'
        expect(page).to have_content 'Target Token aHR0cHM6Ly8xMC4wLjEuODozMDAxfGEyNjNkNWEyLTVkNDUtNGUxNy1iNDQ3LTQ2MGM3YzcwODIy'
        expect(page).to have_content 'Agent Version: 0.1.0'
      end

      within('div', text: 'Brand new target') do
        expect(page).to have_no_content 'Agent Version'
      end
    end

    it 'can create a deployment target' do
      visit '/deployment_targets'

      fill_in 'Name', with: 'Socialize Production Environment'
      fill_in 'Token', with: 'gobbleydeegook'

      click_on 'Save Remote Deployment Target'

      expect(page).to have_content 'Your deployment target was added successfully'
    end

    it 'can link to the deployment' do
      visit '/deployment_targets'

      click_on 'Socialize staging environment'

      page.should have_content 'Deployment ID: 1'
      page.should have_content 'Services: 3'
      page.should have_content 'db-1'
      page.should have_content 'wp-pod'
      page.should have_content 'db-pod'
    end

    it 'can refresh a deployment target' do
      visit '/deployment_targets'

      within('div', text: 'Brand new target') do
        click_on "Refresh"
      end

      expect(current_path).to eq(deployment_targets_path)
    end
  end
end
