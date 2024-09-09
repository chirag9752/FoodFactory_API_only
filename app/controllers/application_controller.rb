class ApplicationController < ActionController::API
    respond_to :json
    skip_before_action :verify_authenticity_token
end
