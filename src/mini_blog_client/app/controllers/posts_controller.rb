class PostsController < ApplicationController
  def index
    response = Net::HTTP.get(URI.parse('http://localhost:3000/v1/posts?limit=10'))
    data_output = JSON.parse(response)
    if data_output["meta"]["code"].to_i == 200
      @data_view = data_output["data"]
    else
      @error = data_output["meta"]["description"]
    end
  #   flash[:notice] = JSON.parse(response)
  #   redirect_to({controller:'users',action:'signup'})
  end
end
