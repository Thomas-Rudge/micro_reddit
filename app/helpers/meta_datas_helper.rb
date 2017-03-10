module MetaDatasHelper
  include PostsHelper

  def get_metadata(url)
    return url if url.blank?
    data = {title: "", thumbnail: ""}

    begin
      url  = add_scheme_to_link(URI.parse(url))
      html = Nokogiri::HTML(get_html(url))
      data[:title] = html.title

      if url.to_s.downcase =~ /[\.jpg|\.jpeg|\.gif|\.png|\.bmp]\z/
        data[:thumbnail] = url.to_s
      else
        ["thumbnail", "og:image", "twitter:image"].each do |tag|
          data[:thumbnail] = html.at(%Q{meta[@property="#{tag}"]}).to_h['content']
          break unless data[:thumbnail].nil?
        end
      end
    rescue
      data = {title: "", thumbnail: ""}
    end

    data
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
