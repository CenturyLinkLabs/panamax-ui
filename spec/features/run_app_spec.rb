require 'spec_helper'

describe 'searching for templates and images' do
  context 'as a user' do
    it 'can run an image' do
      visit '/search?utf8=%E2%9C%93&search_result_set[q]=wordpress'

      within '.image-result', text: 'tutum/wordpress' do
        click_on 'Run Image'
      end

      expect(page).to have_css 'h1', text: 'tutum/wordpress'
    end

    it 'can run a template' do
      visit '/search?utf8=%E2%9C%93&search_result_set[q]=wordpress'

      within '.template-result', text: 'wordpress' do
        click_on 'Run Template'
      end

      expect(page).to have_css 'h1', text: 'tutum/wordpress'
      expect(page).to have_content 'The application was successfully created.'
      expect(page).to have_css '#post-run-html'
    end

    it 'prompts the user to fill in required fields when running a template with required env vars' do
      visit '/search?utf8=%E2%9C%93&search_result_set[q]=wordpress'

      within '.template-result', text: 'Rails' do
        click_on 'Run Template'
      end

      page.should have_content 'It looks like you are trying to run a template with some required fields. Please fill in the values below to continue.'

      fill_in 'GIT_REPO', with: 'repo.git'

      click_on 'Run App'

      expect(page).to have_css 'h1', text: 'tutum/wordpress'
      expect(page).to have_content 'The application was successfully created.'
      expect(page).to have_css '#post-run-html'
    end
  end
end
