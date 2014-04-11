require 'spec_helper'

describe "searching for templates and images" do
  context "as a user" do
    it "can navigate to the search page and see examples" do
      visit "/"

      fill_in "search_form_query", with: "wordpress"

      expect(find_field("search_form_query").value).to eq "wordpress"
      expect(page).to have_content "Examples: wordpress, apache, rails, ubuntu, java"

      click_on "Search"

      expect(page).to have_content "Image to test docker deployments. Has Apache with a 'Hello World' page listening in port 80"
      expect(page).to have_content "a wordpress template"
      expect(page).to have_css '.star-count', text: '3'
      expect(page).to have_css '.image-count', text: '2 Images'

    end

    it 'can run an image' do
      visit '/search?utf8=%E2%9C%93&search_form[query]=wordpress'

      within '.image-result', text: 'Image to test docker deployments' do
        click_on "Run Image"
      end

      expect(page).to have_content 'good job, you created an app'
    end

    it 'can run a template' do
      visit '/search?utf8=%E2%9C%93&search_form[query]=wordpress'

      click_on "Run Template"

      expect(page).to have_content 'good job, you created an app'
    end
  end
end
