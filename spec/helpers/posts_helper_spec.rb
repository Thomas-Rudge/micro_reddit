require 'rails_helper'

RSpec.describe PostsHelper, type: :helper do
  describe "#add_scheme_to_link" do
    let (:https_link)      { URI.parse("https://www.reddit.com") }
    let (:http_link)       { URI.parse("http://www.reddit.com") }
    let (:halfscheme_link) { URI.parse("//www.reddit.com") }
    let (:schemeless_link) { URI.parse("www.reddit.com") }

    it "will return a URI object" do
      expect(add_scheme_to_link https_link).to be_kind_of(URI)
    end

    it "will not change complete links" do
      expect(add_scheme_to_link https_link).to eql https_link
      expect(add_scheme_to_link http_link).to  eql http_link
    end

    it "will add http scheme to incomplete links" do
      expect(add_scheme_to_link halfscheme_link).to eql http_link
      expect(add_scheme_to_link schemeless_link).to eql http_link
    end
  end

  describe "#subreddit_id_from_name" do
  end
end
