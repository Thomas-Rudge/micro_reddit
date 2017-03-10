class MetaDatasController < ApplicationController
  def get_title
    title = get_url_title(params[:url])
    render plain: title
  end
end
