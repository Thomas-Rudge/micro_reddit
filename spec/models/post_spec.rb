require 'rails_helper'

RSpec.describe Post, type: :model do

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_length_of(:title) }
  it { is_expected.to validate_presence_of(:post_type) }
  it { is_expected.to validate_inclusion_of(:post_type).in_array([ 0, 1 ]) }

  it { is_expected.to have_many(:comments) }
  it { is_expected.to belong_to(:subreddit).dependent(:destroy) }
  it { is_expected.to belong_to(:user) }

  ###########
  # T I T L E

  context "when the title is blank" do
    it "will no be valid" do
      type = [true, false].sample ? :text_post : :link_post
      post = FactoryGirl.build(type, title: "  ")

      expect(post.valid?).to be false
      expect(post.errors.details[:title]).to be_an(Array)
      expect(post.errors.details[:title][0][:error]).to eql :blank
    end
  end

  context "when the title has escape characters" do
    it "will remove them before saving" do
      type = [true, false].sample ? :text_post : :link_post
      post = FactoryGirl.build(type, title: "This is\na\test")

      post.save
      post.reload

      expect(post.title).to eql "This is a est"
    end
  end

  context "when the title is longer than 255 chars" do
    it "will not be valid" do
      type = [true, false].sample ? :text_post : :link_post
      post = FactoryGirl.build(type, title: "x" * 256)

      expect(post.valid?).to be false
      expect(post.errors.details[:title]).to be_an(Array)
      expect(post.errors.details[:title][0][:error]).to eql :too_long
    end
  end

  ###################
  # P O S T   T Y P E

  context "when post type not 0 or 1" do
    it "will not be valid" do
      type = [true, false].sample ? :text_post : :link_post
      post = FactoryGirl.build(type, post_type: 5)

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
        post = FactoryGirl.build(:link_post, link: "")

        expect(post.valid?).to be false
        expect(post.errors.details[:link]).to be_an(Array)
        expect(post.errors.details[:link][0][:error]).to eql :invalid
        expect(post.errors.details[:link][1][:error]).to eql :blank
      end
    end

    context "when link is not a valid URL" do
      it "will not be valid" do
        post = FactoryGirl.build(:link_post, link: "ftp://Not_valid")

        expect(post.valid?).to be false
        expect(post.errors.details[:link]).to be_an(Array)
        expect(post.errors.details[:link][0][:error]).to eql :invalid
      end
    end

    context "when post_text is present" do
      it "is removed before saving" do
        post = FactoryGirl.build(:link_post, post_text: "This is a test.")
        post.save
        post.reload

        expect(post.post_text).to be_nil
      end
    end
  end

  context "when post_type is 0" do
    context "when a link is present" do
      it "is removed before saving" do
        post = FactoryGirl.build(:text_post, link: "www.reddit.com")
        post.save
        post.reload

        expect(post.link).to be_nil
      end
    end
  end

  context "when an invalid thumbnail is given" do
    it "will be made valid at save" do
      post = FactoryGirl.build(:text_post, thumbnail: "fttp://invalid.net")
      post.save
      post.reload

      reloaded_thumbnail = URI.parse(post.thumbnail)

      expect(reloaded_thumbnail).to be_kind_of(URI::HTTP)
    end
  end
end
