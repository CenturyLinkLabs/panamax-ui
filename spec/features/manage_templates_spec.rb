require 'spec_helper'

describe 'managing a template' do
  context 'as a user' do
    context 'from a running application' do
      it 'create a template' do
        visit '/applications/2'

        click_on 'Save as Template'

        page.should have_css 'h1', text: 'Save as Template'
      end
    end
  end
end
