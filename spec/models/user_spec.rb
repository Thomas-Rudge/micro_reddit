require 'rails_helper'

RSpec.describe User, type: :model do

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_presence_of(:password_confirmation) }
  it { is_expected.to validate_length_of(:password) }
  it { is_expected.to validate_confirmation_of(:password) }
  it { is_expected.to have_secure_password }
  it { is_expected.to have_many(:posts) }
  it { is_expected.to have_many(:comments) }
  it { is_expected.to have_many(:subscriptions) }
  it { is_expected.to have_many(:subreddits).through(:subscriptions) }

  ##########
  # N A M E

  context "with a blank name" do
    it "will not be valid" do
      user = FactoryGirl.build(:user, name: "     ")

      expect(user.valid?).to be false
      expect(user.errors.details[:name]).to be_an(Array)
      expect(user.errors.details[:name][0][:error]).to eql :blank
    end
  end

  context "with a name of invalid length" do
    it "cannot be too short" do
      user = FactoryGirl.build(:user, name: "Q")

      expect(user.valid?).to be false
      expect(user.errors.details[:name]).to be_an(Array)
      expect(user.errors.details[:name][0][:error]).to eql :too_short
    end

    it "cannot be too short" do
      user = FactoryGirl.build(:user, name: "Q" * 21)

      expect(user.valid?).to be false
      expect(user.errors.details[:name]).to be_an(Array)
      expect(user.errors.details[:name][0][:error]).to eql :too_long
    end
  end

  context "with a name with non-word chars" do
    it "will not be valid" do
      ["foo\tbar", "\ronald", "An\na", "m@thew", "1!1!1!!"].each do |name|
        user = FactoryGirl.build(:user, name: name)

        expect(user.valid?).to be false
        expect(user.errors.details[:name]).to be_an(Array)
        expect(user.errors.details[:name][0][:error]).to eql :invalid
      end
    end
  end

  context "when the name is not all downcase" do
    it "will be saved in downcase" do
      varied_case_name = "Fo0bAr"
      user = FactoryGirl.build(:user, name: varied_case_name)

      expect(user.valid?).to be true
      user.save
      expect(user.reload.name).to eql varied_case_name.downcase
    end
  end

  context "when duplicate names given" do
    it "will mark the duplicate as invalid" do
      user = FactoryGirl.build(:user)
      duplicate_user = user.dup
      duplicate_user.name = user.name.upcase
      user.save

      expect(duplicate_user.valid?).to be false
    end
  end

  #################
  # P A S S W O R D

  context "with a blank password" do
    it "will not be valid" do
      bad_password = " " * 10
      user = FactoryGirl.build(:user,
                               password: bad_password,
                               password_confirmation: bad_password)

      expect(user.valid?).to be false
      expect(user.errors.details[:password]).to be_an(Array)
      expect(user.errors.details[:password][0][:error]).to eql :blank
    end
  end

  context "with a password that is too short" do
    it "will not be valid" do
      bad_password = "x" * 5
      user = FactoryGirl.build(:user,
                               password: bad_password,
                               password_confirmation: bad_password)

      expect(user.valid?).to be false
      expect(user.errors.details[:password]).to be_an(Array)
      expect(user.errors.details[:password][0][:error]).to eql :too_short
    end
  end

  context "without a password confirmation" do
    it "will not be valid" do
      user = FactoryGirl.build(:user, password_confirmation: nil)

      expect(user.valid?).to be false
      expect(user.errors.details[:password_confirmation]).to be_an(Array)
      expect(user.errors.details[:password_confirmation][0][:error]).to eql :blank
    end
  end

  context "when the password confirmation is not the same as the password" do
    it "will not be valid" do
      user = FactoryGirl.build(:user, password_confirmation: "barfoo")

      expect(user.valid?).to be false
      expect(user.errors.details[:password_confirmation]).to be_an(Array)
      expect(user.errors.details[:password_confirmation][0][:error]).to eql :confirmation
    end
  end
end
