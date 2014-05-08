require 'spec_helper'

describe 'managing a service' do
  context 'as a user' do
    it 'can view a service for a running application' do
      visit '/applications/2/services/1'

      expect(page).to have_css 'h1 a', text: 'tutum/wordpress'
      expect(page).to have_css 'h1', text: 'WP_1'
    end
  end
end
