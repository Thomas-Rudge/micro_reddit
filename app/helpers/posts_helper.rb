module PostsHelper
  TEXTPOST_THUMBNAIL = "http://i.imgur.com/vKvm5pe.jpg"

  def add_scheme_to_link(link)
    # Expects and returns an URI object
    if link.scheme.nil? && !link.to_s.blank?
      link.path   = "//#{link.path}" unless link.path.blank? || (link.path.starts_with? "//")
      link.scheme = "http"
    end
    # This ensures the URI type is HTTP instead of Generic
    URI.parse(link.to_s)
  end

  def subreddit_id_from_name(sub)
    sub = Subreddit.find_by(name: sub.downcase)
    sub.nil? ? sub : sub.id
  end
end
