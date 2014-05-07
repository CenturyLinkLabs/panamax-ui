require 'spec_helper'

describe 'managing a service' do
  context 'as a user' do
    it 'can view a service for a running application' do
      visit '/applications/2/services/3'

      expect(page).to have_css 'h1', text: 'tutum/wordpress'
      expect(page).to have_css 'h1', text: 'WP_1'

      within 'div', text: 'Ports' do
        expect(page).to have_content '8080 /tcp'
      end

      within 'div', text: 'Environment Variables' do
        expect(page).to have_content 'DB_PASSWORD pass@word01'
      end

      within 'div', text: 'Service Links' do
        expect(page).to have_content 'DB_1'
      end
    end

    it 'can delete a link' do
      visit '/applications/2/services/3'

      uncheck 'select_link_0'

      click_on 'Update Service'

      expect(page).to have_css 'h1', text: 'tutum/wordpress'
    end

    it 'can navigate back to the application via the crumbs' do
      visit '/applications/2/services/3'

      click_on 'tutum/wordpress'

      page.should have_content 'tutum/wordpress'
    end
  end
end
