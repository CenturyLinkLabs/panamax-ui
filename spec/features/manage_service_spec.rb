require 'spec_helper'

describe 'managing a service' do
  context 'as a user' do
    it 'can view a service for a running application' do
      visit '/applications/2/services/3'

      expect(page).to have_css 'h1', text: 'tutum/wordpress'
      expect(page).to have_css 'h1', text: 'WP_1'

      expect(page).to have_content "8080 /tcp"
    end

    it 'can navigate back to the application via the crumbs' do
      visit '/applications/2/services/3'

      click_on 'tutum/wordpress'

      page.should have_content 'tutum/wordpress'
    end
  end
end
