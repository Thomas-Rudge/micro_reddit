require 'rails_helper'

RSpec.describe SessionsHelper, type: :helper do
  let (:user) { FactoryGirl.create(:user) }

  context "logged in but not remembered" do
    it "will log a user into a session" do
      log_in(user)

      expect(current_user).to eql user
      expect(logged_in?).to be true
      expect(cookies[:user_id]).to be_nil
      log_out
    end
  end

  context "remembered user" do
    it "will remember and forget a user" do
      expect(current_user).to be_nil

      remember(user)
      expect(current_user).to eql user
      expect(cookies.signed[:user_id]).to eql user.id
      expect(cookies[:remember_token]).to eql user.remember_token
      expect(session[:user_id]).to eql user.id

      log_out
      expect(current_user).to be_nil
      expect(cookies.signed[:user_id]).to be_nil
      expect(cookies[:remember_token]).to be_nil
      expect(session[:user_id]).to be_nil
    end

    it "will forget and logout a user when presented with an invalid cookie token" do
      expect(current_user).to be_nil

      remember(user)
      cookies.permanent[:remember_token] = User.new_token

      expect(current_user).to be_nil
      expect(session[:user_id]).to be_nil
      expect(cookies[:remember_token]).to be_nil
      expect(cookies[:user_id]).to be_nil
    end
  end
end
