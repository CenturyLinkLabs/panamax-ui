require 'spec_helper'

describe 'managing images' do
  context 'as a user' do
    it 'can view a list of images' do
      visit '/images'

      expect(page).to have_content 'socialize_api:latest'
    end
  end
end
