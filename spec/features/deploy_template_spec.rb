require 'spec_helper'

describe 'deploying a template from the search results' do
  context 'as a user' do
    it 'can deploy an application' do
      #search for a template
      visit '/search?utf8=%E2%9C%93&search_result_set[q]=wordpress'
      click_on 'Deploy to Target'

      # select a target
      expect(page).to have_title 'Panamax > Select Remote Target'
      expect(page).to have_content 'Socialize staging environment'
      expect(page).to have_content 'Endpoint: https://foo.host'

      within 'li', text: 'Socialize staging environment' do
        click_on 'Select this Target'
      end

      #configure deployment
      expect(page).to have_title 'Panamax > Deploy'
      expect(page).to have_content 'https://social.host'
      expect(page).to have_content 'AWS CLI - wetty'
      expect(page).to have_content 'AWS_CLI_wetty'

      fill_in 'AWS_ACCESS_KEY_ID', with: 'abc123'
      expect(page).to have_field 'AWS_SECRET_ACCESS_KEY', with: 'zzz'

      select '3', from: 'Deploy Count'

      click_on 'Deploy to Target'

      expect(page).to have_title 'Panamax > Socialize production environment'
      expect(page).to have_content 'Deployment successfully triggered'
      expect(page).to have_content 'Socialize production environment'
      expect(page).to have_content 'Services: 3'
      expect(page).to have_content 'db-1'
      expect(page).to have_content 'wp-pod'
      expect(page).to have_content 'db-pod'
    end
  end
end
