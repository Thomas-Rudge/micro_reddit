module ApplicationHelper
  def full_title(page_title = "")
    base_title = "Micro Reddit"
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end
end
