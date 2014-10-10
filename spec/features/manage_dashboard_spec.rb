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

    it 'can link to manage registries' do
      visit '/dashboard'
      click_on 'Manage Registries'

      expect(page).to have_css 'li', text: 'Registries'

      expect(page).to have_content 'my_top_secret_registry'
      expect(page).to have_content 'localhost:5000'
    end


    it 'can link to applications' do
      visit '/dashboard'
      click_on 'tutum/wordpress'

      expect(page).to have_content 'Deployed to'
      expect(page).to have_css 'li', text: 'tutum/wordpress'
    end

    it 'can link to sources' do
      visit '/dashboard'

      expect(page).to have_link 'ctllabs/canonical'
    end
  end
end
