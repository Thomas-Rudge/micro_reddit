require 'rails_helper'

RSpec.describe MetaDatasController, type: :controller do
  describe "#get_title" do
    let (:params_url) { "www.reddit.com" }

    it "will respond with JSON" do
      get :get_title, params: { url: params_url }

      expect(response.content_type).to eq "application/json"
      expect(response.body).to include("title", "thumbnail")
    end
  end
end
