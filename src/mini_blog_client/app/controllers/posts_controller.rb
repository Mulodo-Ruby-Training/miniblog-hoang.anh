class PostsController < ApplicationController
  def index
    response = Net::HTTP.get(URI.parse('http://localhost:3000/v1/posts?limit=10'))
    data_output = JSON.parse(response)
    if data_output["meta"]["code"].to_i == 200
      @data_view = data_output["data"]["source"]
    else
      @error = data_output["meta"]["description"]
    end
  end

  def all
    @page = (params[:page] rescue "")
    @per_page = (params[:per_page] rescue "")
    @order = (params[:order] rescue "")

    response = Net::HTTP.get(URI.parse("http://localhost:3000/v1/posts?page=#{@page}&per_page=#{@per_page}&order=#{@order}"))
    data_output = JSON.parse(response)
    if data_output["meta"]["code"].to_i == 200
      @data_view = data_output["data"]["source"]
    else
      @error = data_output["meta"]["description"]
    end
    @pagination = data_output["data"]["pagination"]
  end
end
