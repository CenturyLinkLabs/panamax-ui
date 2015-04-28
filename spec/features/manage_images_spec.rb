require 'spec_helper'

describe 'managing images' do
  context 'as a user' do
    it 'can view a list of images' do
      visit '/images'

      expect(page).to have_content 'socialize_api:latest'
    end

    it 'can visit the image layers page for an image' do
      visit '/images'

      expect(page).to have_link 'Inspect socialize_api:latest with ImageLayers.io', href: 'https://ImageLayers.io?images=socialize_api:latest'
    end
  end
end
