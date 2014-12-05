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
      expect(flash[:success]).to eq I18n.t('images.destroy.success')
    end

    it 'sets a failure notice when destroy fails' do
      fake_image.stub(:destroy).and_return false
      delete :destroy, id: 2
      expect(flash[:error]).to eq I18n.t('images.destroy.error')
    end

    context 'when an error occurs' do

      before do
        LocalImage.stub(:find).and_raise(StandardError, 'oops')
      end

      it 'redirects the user to the image page' do
        delete :destroy, id: 2
        expect(response).to redirect_to images_url
      end

      it 'flashes the error message' do
        delete :destroy, id: 2
        expect(flash[:alert]).to eq 'oops'
      end
    end
  end

  describe 'DELETE #destroy_multiple' do
    let(:fake_image) { double(:fake_image, id: 1, destroy: true) }

    before do
      LocalImage.stub(:find_by_id).and_return(fake_image)
    end

    it 'redirects to the listing page' do
      delete :destroy_multiple, delete: { 'key_1' => 1 }
      expect(response).to redirect_to images_url
    end

    describe 'sets a success notice when' do
      it 'removing single image' do
        delete :destroy_multiple, delete: { 'key_1' => 1 }
        expect(flash[:notice]).to eq '1 image successfully removed'
      end

      it 'removing multiple images' do
        delete :destroy_multiple, delete: { 'key_1' => 1, 'key_2' => 2 }
        expect(flash[:notice]).to eq '2 images successfully removed'
      end
    end

    describe 'sets alert notice when' do
      before do
        LocalImage.stub(:find_by_id).and_raise(StandardError, 'oops')
      end

      it 'flashes the error message' do
        delete :destroy_multiple, delete: { 'key_1' => 1, 'key_2' => 2 }
        expect(flash[:alert]).to eq '<p>oops</p>'
      end
    end

    context 'when an error occurs' do
      before do
        LocalImage.stub(:batch_destroy).and_raise(StandardError, 'oops')
      end

      it 'redirects the user to the image page' do
        delete :destroy_multiple, delete: { 'key_1' => 1, 'key_2' => 2 }
        expect(response).to redirect_to images_url
      end

      it 'flashes the error message' do
        delete :destroy_multiple, delete: { 'key_1' => 1, 'key_2' => 2 }
        expect(flash[:alert]).to eq 'oops'
      end
    end
  end
end
