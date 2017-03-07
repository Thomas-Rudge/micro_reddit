require 'rails_helper'

RSpec.describe Subreddit, type: :model do

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_length_of(:name) }
  it { is_expected.to validate_presence_of(:mod) }
  it { is_expected.to validate_inclusion_of(:nsfw).in_array([true, false]) }
  it { is_expected.to validate_length_of(:description) }
  it { is_expected.to validate_length_of(:sidebar) }
  it { is_expected.to have_many(:posts) }
  it { is_expected.to have_many(:subscriptions) }
  it { is_expected.to have_many(:users).through(:subscriptions) }

  ####
  # N A M E
  context "with a blank name" do
    it "is not valid" do
      sub = FactoryGirl.build(:subreddit, name: " " * 10)

      expect(sub.valid?).to be false
      expect(sub.errors.details[:name]).to be_an(Array)
      expect(sub.errors.details[:name][0][:error]).to eql :blank
    end
  end

  context "with a name outside the valid length range" do
    it "cannot be too long" do
      sub = FactoryGirl.build(:subreddit, name: "x" * 22)

      expect(sub.valid?).to be false
      expect(sub.errors.details[:name]).to be_an(Array)
      expect(sub.errors.details[:name][0][:error]).to eql :too_long
    end

    it "cannot be too short" do
      sub = FactoryGirl.build(:subreddit, name: "x")

      expect(sub.valid?).to be false
      expect(sub.errors.details[:name]).to be_an(Array)
      expect(sub.errors.details[:name][0][:error]).to eql :too_short
    end
  end

  context "with a name with non-word chars" do
    it "it will not be valid" do
      ["le@rnruby", "p!cs", "scie/nce", "t=i=l"].each do |name|
        sub = FactoryGirl.build(:subreddit, name: name)

        expect(sub.valid?).to be false
        expect(sub.errors.details[:name]).to be_an(Array)
        expect(sub.errors.details[:name][0][:error]).to eql :invalid
      end
    end
  end

  context "when the name is not all downcase" do
    it "will be saved in downcase" do
      varied_case_name = "LeaRnRubY"
      sub = FactoryGirl.build(:subreddit, name: varied_case_name)
      sub.save
      sub.reload

      expect(sub.name).to eql varied_case_name.downcase
    end
  end

  context "when a duplicate name is given" do
    it "will mark the duplicate as invalid" do
      sub = FactoryGirl.build(:subreddit)
      duplicate_sub = sub.dup
      duplicate_sub.name = sub.name.upcase
      sub.save

      expect(duplicate_sub.valid?).to be false
    end
  end

  #######################
  # D E S C R I P T I O N

  context "when a description is too long" do
    it "will not be valid" do
      sub = FactoryGirl.build(:subreddit, description: "x" * 501)

      expect(sub.valid?).to be false
      expect(sub.errors.details[:description]).to be_an(Array)
      expect(sub.errors.details[:description][0][:error]).to eql :too_long
    end
  end

  #########
  # N S F W

  context "when nsfw tag is blank" do
    it "will not be valid" do
      sub = FactoryGirl.build(:subreddit, nsfw: nil)

      expect(sub.valid?).to be false
      expect(sub.errors.details[:nsfw]).to be_an(Array)
      expect(sub.errors.details[:nsfw][0][:error]).to eql :inclusion
    end
  end
end
