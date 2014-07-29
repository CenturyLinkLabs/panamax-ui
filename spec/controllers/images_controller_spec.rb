require 'spec_helper'

describe ImagesController do

  describe 'GET #index' do
    let(:fake_images) { [1, 2] }

    before do
      LocalImage.stub(:all).and_return(fake_images)
    end

    it 'renders the index view' do
      get :index
      expect(response).to render_template :index
    end

    it 'assigns images' do
      get :index
      expect(assigns(:images)).to eq fake_images
    end
  end
end
