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

  describe 'DELETE #destroy' do
    let(:fake_image) { double(:fake_image, id: 2, destroy: true) }

    before do
      LocalImage.stub(:find).and_return(fake_image)
    end

    it 'redirects to the listing page' do
      delete :destroy, id: 2
      expect(response).to redirect_to images_url
    end

    it 'sets a success notice when successful' do
      delete :destroy, id: 2
      expect(flash[:notice]).to eq 'image successfully removed'
    end

    it 'sets a failure notice when destroy fails' do
      fake_image.stub(:destroy).and_return false
      delete :destroy, id: 2
      expect(flash[:error]).to eq 'unable to remove image'
    end
  end
end
