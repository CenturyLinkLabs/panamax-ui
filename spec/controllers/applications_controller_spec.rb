require 'spec_helper'

describe ApplicationsController do
  let(:fake_applications_service) { double(:fake_applications_service) }

  describe 'POST #create' do
    it 'creates an application via the service' do
      ApplicationsService.stub(:new).and_return(fake_applications_service)

      expect(fake_applications_service).to receive(:create).with({'image'=>'some/image'})

      post :create, {application: {image: 'some/image'}}
    end

    it 'says congrats' do
      post :create, {application: {image: 'some/image'}}

      expect(response.body).to have_text 'good job, you created an app'
    end
  end
end
