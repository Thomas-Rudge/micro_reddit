require 'rails_helper'

RSpec.describe MetaDatasHelper, type: :helper do
  describe "#get_url_title" do
    it "will return the title of a webpage" do
      title = "A Test Title"
      html = "<!DOCTYPE html><html><head><title>#{title}</title></head><body></body></html>"
      allow_any_instance_of(MetaDatasHelper).to receive(:get_html).and_return(html)

      expect(get_url_title("http://www.test.com")).to eql title
    end
  end
end
