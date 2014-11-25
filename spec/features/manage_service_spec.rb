require 'spec_helper'

describe 'managing a service' do
  context 'as a user' do
    it 'can navigate back to the application via the crumbs' do
      visit '/apps/2/services/1'

      click_on 'tutum/wordpress'

      page.should have_content 'tutum/wordpress'
    end

    context 'when the service is running' do
      before do
        visit '/apps/2/services/1'
      end

      it 'has a title' do
        expect(page).to have_title 'Panamax > WP_1'
      end

      it 'can view a service for a running application' do
        expect(page).to have_css 'h1', text: 'tutum/wordpress'
        expect(page).to have_css 'h1', text: 'WP_1'

        within '.port-detail', text: 'Ports' do
          expect(page).to have_content '8080 : 80'
        end

        within '.environment-variables', text: 'Environment Variables' do
          expect(page).to have_field('DB_PASSWORD', with: "pass@word01")
        end

        within '.service-links' do
          expect(page).to have_content 'DB_1 : DB'
        end
      end

      it 'can delete a link' do
        uncheck 'select_link_0'

        click_on 'Save all changes'

        expect(page).to have_css 'h1', text: 'tutum/wordpress'
      end

      it 'can delete a port' do
        uncheck 'select_port_binding_0'

        click_on 'Save all changes'

        expect(page).to have_css 'h1', text: 'tutum/wordpress'
      end

      it 'can delete a port' do
        uncheck 'select_port_binding_0'

        click_on 'Save all changes'

        expect(page).to have_css 'h1', text: 'tutum/wordpress'
      end

      it 'can delete an environment variable' do
        uncheck 'select_environment_variable_0'
        click_on 'Save all changes'

        expect(page).to have_css 'h1', text: 'tutum/wordpress'
      end

      it 'can delete a volume' do
        uncheck 'select_volume_0'

        click_on 'Save all changes'

        expect(page).to have_css 'h1', text: 'tutum/wordpress'
      end

      it 'can edit the docker run command' do
        fill_in 'service_command', with: 'rails s'

        click_on 'Save all changes'

        expect(page).to have_css 'h1', text: 'tutum/wordpress'
      end

      it 'displays the service status' do
        within '.service-status' do
          expect(page).to have_content 'Running'
        end
      end

    end

    context 'when the service has an env var with no value' do
      before do
        visit '/apps/2/services/6'
      end

      it 'allows the user to fill in the value' do
        fill_in 'WITHOUT_VALUE', with: 'here is a value'

        click_on 'Save all changes'

        expect(page).to have_css 'h1', text: 'bard'
      end
    end

    context 'when the service is not running' do
      before do
        visit '/apps/2/services/2'
      end

      it 'displays the service status' do
        within '.service-status' do
          expect(page).to have_content 'Loading'
        end
      end
    end
  end
end
