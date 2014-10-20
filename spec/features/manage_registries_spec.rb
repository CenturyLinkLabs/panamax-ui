require 'spec_helper'

describe 'managing registries' do
  context 'as a user' do
    it 'can view a list of registries' do
      visit '/registries'

      expect(page).to have_css('h1', text: 'Registries')

      expect(page).to have_content 'my_top_secret_registry'
      expect(page).to have_content 'localhost:5000'
    end

    it 'displays a form to add a new registry' do
      visit '/registries'

      expect(page).to have_selector 'form.create-registry', visible: false
    end

    it 'does not show the delete button for the Docker Registry' do

      visit '/registries'
      # Docker Hub can't be deleted or edited
      expect('ul.registries li:first-child').to_not have_selector '.actions'
    end

  end
end
