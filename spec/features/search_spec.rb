require 'spec_helper'

describe 'searching for templates and images' do
  context 'as a user' do
    it 'can navigate to the search page and see examples' do
      visit '/'

      # keyword view
      expect(page).to have_css '.collapsed'
      page.find('.toggler').click
      expect(page).to have_content 'Show fewer keywords'

      fill_in 'search_result_set_q', with: 'wordpress'

      expect(find_field('search_result_set_q').value).to eq 'wordpress'
      expect(page).to have_content 'contest (81)'
      expect(page).to have_content 'all (19)'

      within 'form.search-form' do
        click_on 'Search'
      end

      # remote image result
      expect(page.find_link('tutum/wordpress')['href']).to eq "#{DOCKER_INDEX_BASE_URL}u/tutum/wordpress"
      expect(page).to have_content 'Wordpress Docker image - listens in port 80.'
      expect(page).to have_css '.star-count', text: '7'

      # template result
      expect(page).to have_content 'a wordpress template'
      expect(page).to have_content 'More Details'
      expect(page).to have_css '.image-count', text: '2 Images'
      expect(page).to have_css 'img[src="/assets/type_icons/wordpress.svg"]'

      # source template repo blurb
      expect(page).to have_css '.source-repo-blurb'
      expect(page).to have_content 'Did you know you can create your own custom templates to use within Panamax?'
      expect(page.find_link('Learn more')['href']).to eq 'https://github.com/CenturyLinkLabs/panamax-ui/wiki/How-To:-Make-a-Template'
    end

  end
end
