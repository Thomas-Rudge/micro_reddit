module PostsHelper
  def add_scheme_to_link(link)
    # Expects and returns an URI object
    if link.scheme.nil? && !link.to_s.blank?
      link.path = "//#{link.path}" unless link.path.starts_with? "//"
      link.scheme = "http"
    end

    link
  end

  def subreddit_id(sub)
    sub = Subreddit.find_by(name: sub.downcase)
    sub.nil? ? sub : sub.id
  end
end
