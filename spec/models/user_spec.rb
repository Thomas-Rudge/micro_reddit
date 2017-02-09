require 'rails_helper'

RSpec.describe User, type: :model do
  let (:user) { User.new(name:"foobar",
                         password:"password",
                         password_confirmation:"password")}

  context "the base test user" do
    it "will be valid" do
      expect(user.valid?).to be true
    end
  end

  ##########
  # N A M E

  context "with a blank name" do
    it "will not be valid" do
      user.name = "   "

      expect(user.valid?).to be false
      expect(user.errors.details[:name]).to be_an(Array)
      expect(user.errors.details[:name][0][:error]).to eql :blank
    end
  end

  context "with a name of invalid length" do
    it "cannot be too short" do
      user.name = "Q"

      expect(user.valid?).to be false
      expect(user.errors.details[:name]).to be_an(Array)
      expect(user.errors.details[:name][0][:error]).to eql :too_short
    end

    it "cannot be too short" do
      user.name = "Q" * 21

      expect(user.valid?).to be false
      expect(user.errors.details[:name]).to be_an(Array)
      expect(user.errors.details[:name][0][:error]).to eql :too_long
    end
  end

  context "with a name with non-word chars" do
    it "will not be valid" do
      ["foo\tbar", "\ronald", "An\na", "m@thew", "1!1!1!!"].each do |name|
        user.name = name

        expect(user.valid?).to be false
        expect(user.errors.details[:name]).to be_an(Array)
        expect(user.errors.details[:name][0][:error]).to eql :invalid
      end
    end
  end

  context "when the name is not all downcase" do
    it "will be saved in downcase" do
      varied_case_name = "FoObAr"
      user.name = varied_case_name
      user.save
      user.reload

      expect(user.name).to eql varied_case_name.downcase
    end
  end

  context "when duplicate names given" do
    it "will mark the duplicate as invalid" do
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
      user.password =              " " * 10
      user.password_confirmation = " " * 10

      expect(user.valid?).to be false
      expect(user.errors.details[:password]).to be_an(Array)
      expect(user.errors.details[:password][0][:error]).to eql :blank
    end
  end

  context "with a password that is too short" do
    it "will not be valid" do
      user.password =              "x" * 5
      user.password_confirmation = "x" * 5

      expect(user.valid?).to be false
      expect(user.errors.details[:password]).to be_an(Array)
      expect(user.errors.details[:password][0][:error]).to eql :too_short
    end
  end

  context "without a password confirmation" do
    it "will not be valid" do
      user.password_confirmation = nil

      expect(user.valid?).to be false
      expect(user.errors.details[:password_confirmation]).to be_an(Array)
      expect(user.errors.details[:password_confirmation][0][:error]).to eql :blank
    end
  end

  context "when the password confirmation is not the same as the password" do
    it "will not be valid" do
      user.password_confirmation = "barfoo"

      expect(user.valid?).to be false
      expect(user.errors.details[:password_confirmation]).to be_an(Array)
      expect(user.errors.details[:password_confirmation][0][:error]).to eql :confirmation
    end
  end
end
