require 'rails_helper'

RSpec.describe Post, type: :model do
  let (:user) { User.create(name: "test",
                            password: "password",
                            password_confirmation: "password") }

  let (:sub) { Subreddit.create(name: "testing",
                                description: "For testing purposes",
                                nsfw: false) }

  let (:post) { Post.new(title: "This is a test!",
                         link: "http://www.reddit.com",
                         post_text: "This is some text",
                         post_type: 1,
                         user_id: 1,
                         subreddit_id: 1) }

  context "the base post" do
    it "will be valid" do
      expect(post.valid?).to be true
    end
  end

  ###########
  # T I T L E

  context "when the title is blank" do
    it "will no be valid" do
      post.title = " "

      expect(post.valid?).to be false
      expect(post.errors.details[:title]).to be_an(Array)
      expect(post.errors.details[:title][0][:error]).to eql :blank
    end
  end

  context "when the title has escape characters" do
    it "will remove them before saving" do
      post.title = "This is\na\test"
      post.save
      post.reload

      expect(post.title).to eql "This is a est"
    end
  end

  context "when the title is longer than 255 chars" do
    it "will not be valid" do
      post.title = "x" * 256

      expect(post.valid?).to be false
      expect(post.errors.details[:title]).to be_an(Array)
      expect(post.errors.details[:title][0][:error]).to eql :too_long
    end
  end

  ###################
  # P O S T   T Y P E

  context "when post type not 0 or 1" do
    it "will not be valid" do
      post.post_type = 5

      expect(post.valid?).to be false
      expect(post.errors.details[:post_type]).to be_an(Array)
      expect(post.errors.details[:post_type][0][:error]).to eql :inclusion
    end
  end

  #########
  # L I N K

  context "when post_type is 1" do
    context "when link is blank" do
      it "will not be valid" do
        post.post_type = 1 # Explicit
        post.link      = ""

        expect(post.valid?).to be false
        expect(post.errors.details[:link]).to be_an(Array)
        expect(post.errors.details[:link][0][:error]).to eql :invalid
        expect(post.errors.details[:link][1][:error]).to eql :blank
      end
    end

    context "when link is not a valid URL" do
      it "will not be valid" do
        post.post_type = 1 # Explicit
        post.link      = "ftp://Not_valid"

        expect(post.valid?).to be false
        expect(post.errors.details[:link]).to be_an(Array)
        expect(post.errors.details[:link][0][:error]).to eql :invalid
      end
    end

    context "when post_text is present" do
      it "is removed before saving" do
        post.save
        post.reload

        expect(post.post_text).to be_nil
      end
    end
  end

  context "when post_type is 0" do
    context "when the post_text is blank" do
      it "will not be valid" do
        post.post_type = 0
        post.post_text = "   "

        expect(post.valid?).to be false
        expect(post.errors.details[:post_text]).to be_an(Array)
        expect(post.errors.details[:post_text][0][:error]).to eql :blank
      end
    end

    context "when a link is present" do
      it "is removed before saving" do
        post.post_type = 0
        post.save
        post.reload

        expect(post.link).to be_nil
      end
    end
  end
end
