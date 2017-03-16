require 'rails_helper'

RSpec.describe MetaDatasHelper, type: :helper do
  describe "#get_url_title" do
    it "will return the title of a webpage" do
      title = "A Test Title"
      image = "http://host/thumbnail.jpg"
      html = %Q{<!DOCTYPE html><html><head><title>#{title}</title>
<meta property="og:image" content="#{image}"></head><body></body></html>}
      allow_any_instance_of(MetaDatasHelper).to receive(:get_html).and_return(html)

      expect(get_metadata("http://www.test.com")).to include(:title=>title, :thumbnail=>image)
    end
  end
end
