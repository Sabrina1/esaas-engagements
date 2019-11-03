class MyprojectsController < ApplicationController
  before_action :set_app, only: [:show, :edit, :update, :destroy]
  skip_before_filter :logged_in?, :only => :index
  skip_before_filter :auth_user?, :only => :index
  def index
    @current_user = User.find_by_id(session[:user_id])
    if @current_user
      orgs = Org.for_user(@current_user.id) #use id '13' for testing
      @apps = App.for_orgs(orgs, limit=@each_page, offset=0)
      deploy_vet_map(@current_user.id)
    else
      deploy_vet_map
      @apps = App.limit(@each_page).offset(0)
    end
    total_app = @total_deploy + @total_vet

    page_default_and_update("app", total_app)
    change_page_num("app", total_app)

    respond_to do |format|
      format.json { render :json => @apps.featured }
      format.html
    end
  end

  # count the number of apps for each status and
  # the total number of apps for each category
  def deploy_vet_map(orgs=nil)
    status_map = App.status_count_for_orgs(orgs)
    @deployment_map = {}
    @vetting_map = {}
    @total_deploy = 0
    @total_vet = 0
    status_map.each do |status, count|
      status_str = App.statuses.keys[status]
      if App.getAllVettingStatuses.include? status_str.to_sym
        @vetting_map[status_str] = count
        @total_vet += count
      else
        @deployment_map[status_str] = count
        @total_deploy += count
      end
    end
  end
end
