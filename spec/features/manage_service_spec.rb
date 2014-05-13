require 'spec_helper'

describe 'managing a service' do
  context 'as a user' do
    it 'can navigate back to the application via the crumbs' do
      visit '/applications/2/services/1'

      click_on 'tutum/wordpress'

      page.should have_content 'tutum/wordpress'
    end

    context 'when the service is running' do
      before do
        visit '/applications/2/services/1'
      end

      it 'can view a service for a running application' do
        expect(page).to have_css 'h1', text: 'tutum/wordpress'
        expect(page).to have_css 'h1', text: 'WP_1'

        within '.port-detail', text: 'Ports' do
          expect(page).to have_content '8080 /tcp'
        end

        within '.environment-variables', text: 'Environment Variables' do
          expect(page).to have_content 'DB_PASSWORD pass@word01'
        end

        within '.service-links', text: 'Service Links' do
          expect(page).to have_content 'DB_1'
        end
      end

      it 'can delete a link' do
        uncheck 'select_link_0'

        click_on 'Save all changes'

        expect(page).to have_css 'h1', text: 'tutum/wordpress'
      end

      it 'can delete a port' do
        uncheck 'select_port_0'

        click_on 'Save all changes'

        expect(page).to have_css 'h1', text: 'tutum/wordpress'
      end

      it 'can delete a port' do
        uncheck 'select_port_0'

        click_on 'Save all changes'

        expect(page).to have_css 'h1', text: 'tutum/wordpress'
      end

      it 'activates the service details' do
        expect(page.find('.service-details')['class']).to_not include 'loading'
      end

    end

    context 'when the service is not running' do
      before do
        visit '/applications/2/services/2'
      end

      it 'does not activate the service details' do
        expect(page.find('.service-details')['class']).to include 'loading'
      end
    end
  end
end
