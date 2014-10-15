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

      expect(page).to have_selector 'form.create-registry'
    end

  end
end
