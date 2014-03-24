require 'spec_helper'

describe SearchController do
  let(:fake_search_object) { double(:fake_search_object) }

  describe "GET #new" do
    it "creates and assigns a search object" do
      expect(Search).to receive(:new).and_return(fake_search_object)

      get :new

      expect(assigns(:search)).to eq fake_search_object
    end
  end
end
