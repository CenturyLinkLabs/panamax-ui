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

        expect(page).to have_link('create a new Github repo', href: 'https://github.com/new')

        fill_in 'Template Name', with: 'My Template'
        fill_in 'Template Author', with: 'test@example.com'
        fill_in 'Template Description', with: 'generic wordpress installation'
        fill_in 'Keywords', with: 'wordpress, mysql, blog'
        choose 'Java'

        fill_in 'Add some instructions to help people use your template.', with: '##Markdown##'

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

          visit '/templates/new?app_id=1'

          expect(page).to have_link(
            'Generate a Github access token',
            href: 'https://github.com/settings/tokens/new?scope=repo,user:email'
          )

          expect(page).to have_unchecked_field 'user_subscribe'
          expect(page).to have_content 'Sign up for our newsletter - Get all the latest news'

          fill_in 'Github Token', with: 'abc123'
          click_on 'Save Token'

          expect(page).to have_content 'Save as Template'
        end
      end

      context 'when user does not have an email' do

        before do
          user = User.new(github_access_token_present: true, email: '', github_username: 'bar')
          User.stub(:find).and_return(user)
          user.stub(:update_attributes).and_return(true)
        end

        it 'allows the user to request and enter a token' do

          visit '/templates/new?app_id=1'

          expect(page).to have_link(
                              'Generate a Github access token',
                              href: 'https://github.com/settings/tokens/new?scope=repo,user:email'
                          )

          expect(page).to have_unchecked_field 'user_subscribe'
          expect(page).to have_content 'Sign up for our newsletter - Get all the latest news'

          fill_in 'Github Token', with: 'abc123'
          click_on 'Save Token'

          expect(page).to have_content 'Save as Template'
        end
      end

      context 'when user does not have a github username' do

        before do
          user = User.new(github_access_token_present: true, email: 'foo', github_username: '')
          User.stub(:find).and_return(user)
          user.stub(:update_attributes).and_return(true)
        end

        it 'allows the user to request and enter a token' do

          visit '/templates/new?app_id=1'

          expect(page).to have_link(
                              'Generate a Github access token',
                              href: 'https://github.com/settings/tokens/new?scope=repo,user:email'
                          )

          expect(page).to have_unchecked_field 'user_subscribe'
          expect(page).to have_content 'Sign up for our newsletter - Get all the latest news'

          fill_in 'Github Token', with: 'abc123'
          click_on 'Save Token'

          expect(page).to have_content 'Save as Template'
        end
      end

    end
  end
end
