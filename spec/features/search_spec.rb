require 'spec_helper'

describe 'searching for templates and images' do
  context 'as a user' do
    it 'can navigate to the search page and see examples' do
      visit '/'

      expect(page).to have_title 'Panamax > Search'

      fill_in 'search_result_set_q', with: 'wordpress'

      expect(find_field('search_result_set_q').value).to eq 'wordpress'
      expect(page).to have_content 'contest (81)'
      expect(page).to have_content 'all (19)'

      within 'form.search-form' do
        click_on 'Search'
      end

      expect(page).to have_title 'Panamax > Search Results'

      # remote image result
      expect(page.find_link('Docker Hub')['href']).to eq "#{DOCKER_INDEX_BASE_URL}u/tutum/wordpress"
      expect(page.find_link('Inspect this image')['href']).to eq "#{IMAGELAYERS_URL}?images=tutum/wordpress"
      expect(page).to have_content 'Wordpress Docker image - listens in port 80.'
      expect(page).to have_css '.star-count', text: '7'

      # template result
      expect(page).to have_content 'a wordpress template'
      expect(page).to have_content 'More Details'
      expect(page.find_link('Inspect template')['href']).to eq "#{IMAGELAYERS_URL}?images=centurylink/aws-cli-wetty:latest"
      expect(page).to have_css '.image-count', text: '2 Images'
      expect(page).to have_css '.microcopy', text: 'UTC'
      expect(page).to have_css 'img[src="/assets/type_icons/wordpress.svg"]'

      # source template repo blurb
      expect(page).to have_css '.source-repo-blurb'
      expect(page).to have_content 'Did you know you can create your own custom templates to use within Panamax?'
      expect(page.find_link('Learn more')['href']).to \
        eq 'https://github.com/CenturyLinkLabs/panamax-ui/wiki/How-To:-Make-a-Template'
    end

    it 'can view template details' do
      visit '/'

      fill_in 'search_result_set_q', with: 'wordpress'

      within 'form.search-form' do
        click_on 'Search'
      end

      within '.template-result' do
        click_on 'More Details'
      end

      expect(page).to have_content 'Template Images'
      expect(page).to have_content 'centurylink/aws-cli-wetty:latest'
      expect(page).to have_link 'View on Docker Hub', href: 'https://registry.hub.docker.com/u/centurylink/aws-cli-wetty'

      expect(page).to have_content 'Documentation'
      expect(page).to have_content 'AWS CLI 1.0 - wetty terminal' # did't include all the documentation here
    end

  end
end
