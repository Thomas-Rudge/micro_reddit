require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "#new" do

    it "will assign a new user object" do
      get :new
      expect(assigns(:user)).to be_a(User)
    end

    it "will render the new user (signup) page" do
      get :new
      expect(response.content_type).to eq "text/html"
      expect(subject).to render_template("users/new")
    end
  end

  describe "#create" do
    context "When supplied with invalid params" do
      let (:invalid_params) { {user:
                                {name:                  "bad@user",
                                 password:              "password",
                                 password_confirmation: "password" }} }

      it "will create a user object with the invalid params and fail to save it" do
        post :create, params: invalid_params
        user = assigns(:user)

        expect(user).to be_a(User)
        expect(user.name).to         eql invalid_params[:user][:name]
        expect(user.password).to     eql invalid_params[:user][:password]
        expect(user.persisted?).to   be false
        expect(session[:user_id]).to be_nil
      end

      it "will render the new user (signup) view" do
        post :create, params: invalid_params

        expect(subject).to render_template("users/new")
      end
    end

    context "when supplied with valid params" do
      let (:valid_params) { {user:
                              {name:                  "test_user",
                               password:              "password",
                               password_confirmation: "password" }} }

      it "will create a user object with the valid params and save it" do
        post :create, params: valid_params
        user = assigns(:user)

        expect(user).to be_a(User)
        expect(user.name).to       eql valid_params[:user][:name]
        expect(user.password).to   eql valid_params[:user][:password]
        expect(user.reload.id).not_to  be_nil
        expect(session[:user_id]).to eql user.id
      end

      it "will redirect to root_url" do
        post :create, params: valid_params

        expect(subject).to redirect_to root_url
      end
    end
  end
end
