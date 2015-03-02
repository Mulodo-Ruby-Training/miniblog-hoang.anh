class ErrorsController  < ApplicationController
    respond_to :json
    skip_before_filter :verify_authenticity_token

    def not_found
      render :json => {code:ERROR_NOT_FOUND, message:MSG_NOT_FOUND}.to_json, :status => 404
    end

    def exception
      render :json => {code:ERROR_INTERNAL_SERVER, message:MSG_INTERNAL_SERVER}.to_json, :status => 500
    end

end