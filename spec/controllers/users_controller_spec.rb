require 'spec_helper'

describe UsersController do

  let(:user) { double(:user) }
  let(:update_params) { { 'email' => 'test@example.com' } }

  before do
    User.stub(:find).and_return(user)
  end

  describe 'put #update' do
    before do
      user.stub(:update_attributes)
      request.env['HTTP_REFERER'] = '/some/origin'
    end

    it 'updates the user' do
      expect(user).to receive(:update_attributes).with(update_params)
      put :update, user: update_params
    end

    it 'redirects to the previous page' do
      put :update, user: update_params
      expect(response).to redirect_to '/some/origin'
    end

    it 'sets a flash message indicating successful update' do
      user.stub(:update_attributes).and_return(true)
      put :update, user: update_params
      expect(flash[:success]).to eq 'Your GitHub token has been saved.'
    end

    it 'sets a flash alert if the token could not be saved' do
      user.stub(:update_attributes).and_return(false)
      put :update, user: update_params
      expect(flash[:alert]).to_not be blank?
    end

    context 'when an error occurs' do

      before do
        user.stub(:update_attributes).and_raise('oops')
      end

      it 'flashes an error message' do
        put :update, user: update_params
        expect(flash[:alert]).to eq 'oops'
      end

      it 'redirects to the previous page' do
        put :update, user: update_params
        expect(response).to redirect_to '/some/origin'
      end
    end
  end
end
