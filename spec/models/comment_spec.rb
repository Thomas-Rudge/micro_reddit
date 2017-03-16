require 'rails_helper'

RSpec.describe Comment, type: :model do

  it { is_expected.to validate_length_of(:content) }

  it { is_expected.to have_many(:votes).dependent(:destroy) }
  it { is_expected.to belong_to(:post) }
  it { is_expected.to belong_to(:user) }

  context "an empty comment" do
    it "will not be valid" do
      comment = FactoryGirl.build(:comment, content: "")

      expect(comment.valid?).to be false
      expect(comment.errors.details[:content]).to be_an(Array)
      expect(comment.errors.details[:content][0][:error]).to eql :too_short
    end
  end

  context "a comment over a thousand chars" do
    it "will not be valid" do
      comment = FactoryGirl.build(:comment, content: "x" * 1001)

      expect(comment.valid?).to be false
      expect(comment.errors.details[:content]).to be_an(Array)
      expect(comment.errors.details[:content][0][:error]).to eql :too_long
    end
  end
end
