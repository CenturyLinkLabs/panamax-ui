require 'spec_helper'

describe 'manage dashboard' do
  context 'as a user' do
    it 'can view a management dashboard' do
      visit '/dashboard'

      expect(page).to have_content 'Dashboard'
    end

    it 'can link to manage applications' do
      visit '/dashboard'
      click_on 'Manage Applications'

      expect(page).to have_css 'li', text: 'My Applications'
    end

    it 'can link to manage sources' do
      visit '/dashboard'
      click_on 'Manage Sources'

      expect(page).to have_css 'li', text: 'Sources'
    end

    it 'can link to manage images' do
      visit '/dashboard'
      click_on 'Manage Images'

      expect(page).to have_css 'li', text: 'Images'
    end

    it 'can link to applications' do
      visit '/dashboard'
      click_on 'tutum/wordpress'

      expect(page).to have_content 'Deployed to'
      expect(page).to have_css 'li', text: 'tutum/wordpress'
    end
  end
end
