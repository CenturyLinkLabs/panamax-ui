require 'spec_helper'

describe 'managing an application' do
  context 'as a user' do
    context 'from an application' do
      it 'can navigate to a running service' do
        visit '/applications/2'

        within '.category-panel li', text: 'tutum_wordpress_1' do
          click_on 'details'
        end

        expect(page).to have_css 'h1', text: 'tutum/wordpress'
        expect(page).to have_css 'h1', text: 'WP_1'
      end

      it 'can destroy a running service' do
        visit '/applications/2'

        within 'ul.services li .actions' do
          click_on 'delete'
        end

        assert_redirected_to application_path 2
      end
    end
  end
end
