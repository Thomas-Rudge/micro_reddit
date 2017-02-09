require 'rails_helper'

RSpec.describe Comment, type: :model do
  before(:all) do
    @user = User.create(name: "test",
                        password: "password",
                        password_confirmation: "password")

    @sub = Subreddit.create(name: "testing",
                            description: "For testing purposes",
                            nsfw: false)

    @post = Post.create(title: "This is a test!",
                        link: "http://www.reddit.com",
                        post_text: "This is some text",
                        post_type: 1,
                        user_id: 1,
                        subreddit_id: 1)

    @comment = Comment.new(content: "Wow! Cool website\nThanks",
                           user_id: 1,
                           post_id: 1)
  end

  context "the base comment" do
    it "will be valid" do
      expect(@comment.valid?).to be true
    end
  end

  context "an empty comment" do
    it "will not be valid" do
      @comment.content = ""

      expect(@comment.valid?).to be false
      expect(@comment.errors.details[:content]).to be_an(Array)
      expect(@comment.errors.details[:content][0][:error]).to eql :too_short
    end
  end

  context "a comment over a thousand chars" do
    it "will not be valid" do
      @comment.content = "x" * 1001
      puts "Comment #{@comment.valid?} -> #{@comment.errors.details}"
      expect(@comment.valid?).to be false
      expect(@comment.errors.details[:content]).to be_an(Array)
      expect(@comment.errors.details[:content][0][:error]).to eql :too_long
    end
  end
end
