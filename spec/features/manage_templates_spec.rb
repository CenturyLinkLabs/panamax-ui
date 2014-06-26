require 'spec_helper'

describe 'managing a template' do

  context 'as a user' do

    context 'from a running application' do

      it 'allows template creation' do
        visit '/apps/2'

        click_on 'Save as Template'

        expect(page).to have_css 'h1', text: 'Save as Template'

        expect(page).not_to have_content 'Generate a Github access token'

        expect(page).to have_content 'Username: githubuser'
        expect(page).to have_content 'Email Address: testuser@example.com'

        expect(page).to have_select 'template_form_repo', options: ['ctlc/docker-mysql', 'ctlc/docker-apache']

        fill_in 'Template Name', with: 'My Template'
        fill_in 'Template Author', with: 'test@example.com'
        fill_in 'Template Description', with: 'generic wordpress installation'
        fill_in 'Keywords', with: 'wordpress, mysql, blog'
        choose 'Java'

        click_on 'Publish Your Template'

        expect(page).to have_content 'Template successfully created.'
      end

      context 'when user does not have a github access token' do

        before do
          user = User.new(github_access_token_present: false)
          User.stub(:find).and_return(user)
          user.stub(:update_attributes).and_return(true)
        end

        it 'allows the user to request and enter a token' do

          visit '/templates/new'

          expect(page).to have_link(
            'Generate a Github access token',
            href: 'https://github.com/settings/tokens/new?scope=repo,user:email'
          )

          fill_in 'Github Token', with: 'abc123'
          click_on 'Save Token'

          expect(page).to have_content 'Save as Template'
        end
      end
    end
  end
end
