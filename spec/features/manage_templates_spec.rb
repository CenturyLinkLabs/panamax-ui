require 'spec_helper'

describe 'managing a template' do

  context 'as a user' do

    context 'from a running application' do

      it 'creates a template' do
        visit '/applications/2'

        click_on 'Save as Template'

        expect(page).to have_css 'h1', text: 'Save as Template'

        expect(page).not_to have_content 'Generate a Github access token'

        expect(page).to have_content 'We haz your Github access token!'
      end

      context 'when user does not have a github access token' do

        it 'has a link to generate a new github token' do
          User.stub(:find).and_return(double(:user, github_access_token_present?: false))

          visit '/templates/new'

          expect(page).to have_link(
            'Generate a Github access token',
            href: 'https://github.com/settings/tokens/new?scope=repo,user:email'
          )
        end
      end
    end
  end
end
