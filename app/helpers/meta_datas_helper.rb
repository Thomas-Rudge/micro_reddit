module MetaDatasHelper
  include PostsHelper

  IMG_REGEX         = /(\.jpg|\.jpeg|\.gif|\.png|\.bmp)\z/
  DEFAULT_THUMBNAIL = "http://i.imgur.com/D6QAHtY.jpg"
  IMAGE_META_TAGS   = ["thumbnail", "og:image", "twitter:image"]
  DEFAULT_METADATA  = {title: "", thumbnail: DEFAULT_THUMBNAIL}

  def get_metadata(url)
    data = DEFAULT_METADATA
    return data if url.blank?


    begin
      url  = add_scheme_to_link(URI.parse(url))
      html = Nokogiri::HTML(get_html(url))
      data[:title] = html.title

      # If the link is an image, try to set the thumbnail image
      if url.to_s.downcase =~ IMG_REGEX
        url = set_thumbnail_for_image_links(url)
        data[:thumbnail] = url
      else
        IMAGE_META_TAGS.each do |tag|
          data[:thumbnail] = html.at(%Q{meta[@property="#{tag}"]}).to_h['content']
          break unless data[:thumbnail].nil?
        end

        data[:thumbnail] = DEFAULT_THUMBNAIL if data[:thumbnail].nil?
      end
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

  def set_thumbnail_for_image_links(url)
    if url.host.ends_with? "imgur.com"
      url = url.to_s.gsub(IMG_REGEX, "s#{$1}")
    elsif url.host.ends_with? "flickr.com"
      url = url.to_s.gsub(IMG_REGEX, "t#{$1}")
    end

    url.to_s
  end

  def referring_subreddit(referer)
    num = referer =~ /\/r\/*/

    referer = num.nil? ? "" : referer[num+3..-1]
  end

  def post_type(link)
    # 1 = link post, 0 = text post
    link.blank? ? 0 : 1
  end
end
