require 'spec_helper'

describe 'deploying a template from the search results' do
  context 'as a user' do
    it 'can deploy an application' do
      #search for a template
      visit '/search?utf8=%E2%9C%93&search_result_set[q]=wordpress'

      click_on 'Deploy to Target'

      # select a target
      expect(page).to have_content 'Socialize staging environment'
      expect(page).to have_content 'Endpoint: https://foo.host'

      within 'li', text: 'Socialize staging environment' do
        click_on 'Deploy to Target'
      end

      #configure deployment
      expect(page).to have_content 'https://social.host'
      expect(page).to have_content 'AWS CLI - wetty'

      click_on 'Deploy to Target'

      page.should have_content 'Deployment successfully triggered'

    end
  end
end
