describe "searching for templates and images" do
  context "as a user" do
    it "can navigate to the search page and see examples" do
      visit "/"

      fill_in "Command", with: "nginx"

      expect(find_field("Command").value).to eq "nginx"
      expect(page).to have_content "Examples: wordpress, apache, rails, ubuntu, java"
    end
  end
end
