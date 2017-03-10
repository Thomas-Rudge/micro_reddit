module PostsHelper
  def add_scheme_to_link(link)
    # Expects an URI object
    if link.scheme.nil? && !link.to_s.blank?
      link.path = "//#{link.path}" unless link.path.starts_with? "//"
      link.scheme = "http"
    end

    link
  end
end
