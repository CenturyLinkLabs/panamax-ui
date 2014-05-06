require 'spec_helper'

describe 'applications dashboard' do
  context 'as a user' do
    context 'from an application' do
      it 'can navigate to application details' do
        visit '/applications'

        within 'section.applications .name' do
          click_on 'tutum/wordpress'
        end

        expect(page).to have_css 'h1', text: 'Manage'
        expect(page).to have_css 'h1', text: 'tutum/wordpress'
      end

      it 'can navigate to application details via icon' do
        visit '/applications'

        within 'section.applications .actions' do
          click_on 'edit'
        end

        expect(page).to have_css 'h1', text: 'Manage'
        expect(page).to have_css 'h1', text: 'tutum/wordpress'
      end
    end
  end
end