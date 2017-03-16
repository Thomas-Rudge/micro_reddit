class MetaDatasController < ApplicationController
  def get_title
    data = get_metadata(params[:url])
    render json: data.to_json
  end
end
