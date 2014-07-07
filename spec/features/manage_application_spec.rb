require 'spec_helper'

describe 'managing an application' do
  context 'as a user' do
    context 'from an application' do

      it 'can navigate to the search page' do
        visit '/apps/2'

        within 'nav li.search-link' do
          click_on 'Search'
        end

        expect(page).to have_css 'h1', text: 'Search'
      end

      it 'can navigate to the manage page' do
        visit '/apps/2'

        within 'nav li.manage-link' do
          click_on 'Manage'
        end

        expect(page).to have_css 'h1', text: 'Manage'
      end

      it 'can navigate to a running service' do
        visit '/apps/2'

        within '.category-panel:first-child li', text: 'tutum_wordpress_1' do
          click_on 'details'
        end

        expect(page).to have_css 'h1', text: 'tutum/wordpress'
        expect(page).to have_css 'h1', text: 'WP_1'
      end

      it 'can create a template from an app' do
        visit '/apps/2'

        click_on 'Save as Template'

        expect(page.find('#template_form_app_id', visible: false).value).to eq '2'
      end

      it 'can destroy a running service' do
        visit '/apps/2'

        within 'ul.services li .actions' do
          click_on 'delete'
        end

        expect(page).to have_css 'h1', text: 'tutum/wordpress'
        # TODO: assert flash message
      end

      it 'shows a button to add a service to the app' do
        visit '/apps/2'

        within '.category-panel:first-child' do
          expect(page).to have_css 'a.add-service', text: 'Add a Service'
        end
      end

      it 'shows the deployment environment' do
        visit '/apps/2'

        within '.deployment-details' do
          expect(page).to have_css '.deployment-env', text: 'Deployed to: CoreOS Local'
        end
      end

    end

    context 'perform actions' do
      it 'can rebuild an application' do
        visit '/apps/2'

        click_on 'rebuild'

        expect(page).to have_css 'div.notice-success', text: 'The application was successfully rebuilt.'
      end

    end

  end
end
