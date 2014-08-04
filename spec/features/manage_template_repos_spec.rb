require 'spec_helper'

describe 'managing template repos' do

  context 'as a user' do

    it 'can view a list of template repos' do

      visit '/template_repos'

      expect(page).to have_css 'h1', text: 'Sources'

    end

  end

end
