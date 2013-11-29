class Admin::UsersController < ApplicationController
  layout "admin"
  before_action :signed_in_supervisor

  def index
    if params[:course_id]
      course = Course.find params[:course_id]
      @users = course.current_users
        .paginate page: params[:page], per_page: Settings.items.per_page
    else
      @users = User.all.paginate page: params[:page], 
        per_page: Settings.items.per_page
    end
    @courses = Course.all
  end
  
  def show
    @user = User.find params[:id]
    @enrollment = @user.current_enrollment
    @course = @user.current_course
    @activities = @user.activities
      .paginate page: params[:page], per_page: Settings.items.per_page
  end
end