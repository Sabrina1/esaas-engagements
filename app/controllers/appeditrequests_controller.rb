class AppeditrequestsController < ApplicationController
  before_action :auth_user?

  def index
    respond_to do |format|
      format.json { render :json => AppEditRequest.featured }
      format.html
    end
  end

  def show
    @edit_request = AppEditRequest.find(params[:id])
    @app = App.find(@edit_request.app_id)
    @description_updated = @edit_request.description != @app.description
    @features_updated = @edit_request.features != @app.features
  end

  def auth_user?
    User.find_by_id(session[:user_id])&.coach?
  end

end
