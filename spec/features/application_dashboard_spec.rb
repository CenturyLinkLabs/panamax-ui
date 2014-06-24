require 'spec_helper'

describe 'applications dashboard' do
  context 'as a user' do
    context 'from an application' do
      it 'can navigate to application details' do
        visit '/apps'

        within 'section.applications .name' do
          click_on 'tutum/wordpress'
        end

        expect(page).to have_css 'h1', text: 'Manage'
        expect(page).to have_css 'h1', text: 'tutum/wordpress'
      end

      it 'can rebuild the application' do
        visit '/apps'

        click_on 'rebuild'

        expect(page).to have_css 'div.notice-success', text: 'The application was successfully rebuilt.'
      end
    end
  end
end
