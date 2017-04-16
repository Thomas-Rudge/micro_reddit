module PostsHelper
  def add_scheme_to_link(link)
    link = URI.parse(link)
    if link.scheme.nil? && !link.to_s.blank?
      link.path   = "//#{link.path}" unless link.path.blank? || (link.path.starts_with? "//")
      link.scheme = "http"
      # This ensures the URI type is HTTP instead of Generic
      link = URI.parse(link.to_s.downcase)
    elsif !["http", "https"].include? link.scheme
      link = ""
    end

    link.to_s
  end

  def subreddit_id_from_name(sub)
    sub = Subreddit.find_by(name: sub.downcase)
    sub.nil? ? sub : sub.id
  end
end
