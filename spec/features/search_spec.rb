require 'spec_helper'

describe "searching for templates and images" do
  context "as a user" do
    it "can navigate to the search page and see examples" do
      visit "/"

      fill_in 'search_result_set_q', with: "wordpress"

      expect(find_field('search_result_set_q').value).to eq "wordpress"
      expect(page).to have_content "Or, try one of these example searches"

      within 'form' do
        click_on "Search"
      end

      # remote image result
      expect(page.find_link("tutum/wordpress")['href']).to eq 'https://index.docker.io/u/tutum/wordpress'
      expect(page).to have_content "Wordpress Docker image - listens in port 80."
      expect(page).to have_css '.star-count', text: '7'

      # template result
      expect(page).to have_content "a wordpress template"
      expect(page).to have_css '.image-count', text: '2 Images'
      expect(page).to have_css 'img[src="/icons/icon.png"]'
    end
  end
end
