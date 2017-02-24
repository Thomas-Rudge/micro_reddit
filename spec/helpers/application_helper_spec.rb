require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do

  describe "#full_title" do
    let (:base_title) { "Micro Reddit" }
    let (:page_title) { "Test" }

    it "return base title when no page title given" do
      expect(full_title).to eql base_title
    end

    it "adds given page title to base title" do
      expect(full_title(page_title)).to eql "#{page_title} | #{base_title}"
    end
  end
end
