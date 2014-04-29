require 'spec_helper'

describe 'managing an application' do
  context 'as a user' do
    context 'from an application' do
      it 'can navigate to a running service' do
        visit '/applications/2'

        within '.category-panel', text: 'Web Tier' do
          click_on 'tutum_wordpress_1'
        end

        expect(page).to have_css 'h1', text: 'tutum/wordpress'
        expect(page).to have_css 'h1', text: 'WP_1'
      end
    end
  end
end
