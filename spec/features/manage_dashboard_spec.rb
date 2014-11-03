require 'spec_helper'

describe 'manage dashboard' do
  context 'as a user' do
    it 'can view a management dashboard' do
      visit '/dashboard'

      expect(page).to have_content 'Dashboard'
    end

    it 'can link to manage applications' do
      visit '/dashboard'
      find('a', text: 'Manage your Applications').click

      expect(page).to have_css 'li', text: 'My Applications'
    end

    it 'can link to manage sources' do
      visit '/dashboard'
      find('a', text: 'Manage your Sources').click

      expect(page).to have_css 'li', text: 'Sources'
    end

    it 'can link to manage images' do
      visit '/dashboard'
      find('a', text: 'Manage your Images').click

      expect(page).to have_css 'li', text: 'Images'
    end

    it 'can link to remote deployment targets images' do
      visit '/dashboard'
      find('a', text: 'Manage your Targets').click

      expect(page).to have_css 'li', text: 'Remote Deployment Targets'
    end

    it 'can link to registries' do
      visit '/dashboard'
      find('a', text: 'Manage your Registries').click

      expect(page).to have_css 'li', text: 'Registries'
    end
  end
end
