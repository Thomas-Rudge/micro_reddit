module MetaDatasHelper
  include PostsHelper

  def get_url_title(url)
    return url if url.blank?

    url  = add_scheme_to_link(URI.parse(url))
    html = get_html(url)

    begin
      Nokogiri::HTML(html).title
    rescue
      ""
    end
  end

  def toggle_http_ssl(url)
    case url.scheme
      when "http"  then url.scheme = "https"
      when "https" then url.scheme = "http"
    end ; nil
  end

  def get_html(url)
    begin
      html = open(url.to_s).read
    rescue
      toggle_http_ssl(url)

      begin
        html = open(url.to_s).read
      rescue
        html = ""
      end
    end

    html.sub(/^<!DOCTYPE html(.*)$/, '<!DOCTYPE html>')
  end
end
