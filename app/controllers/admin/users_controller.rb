class Admin::UsersController < ApplicationController
  layout "admin"
  before_action :signed_in_supervisors, only: [:show, :index]
  before_action :load_object, only: [:show]
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
    @enrollment = @user.current_enrollment
    @course = @user.current_course
    @activities = @user.activities
      .paginate page: params[:page], per_page: Settings.items.per_page
  end

  private
  def load_object
    @user = User.find params[:id]
  end
  
  def signed_in_supervisors
    unless supervisor_signed_in?
      store_location!
      redirect_to  admin_signin_path, notice: "Please sign in."
    end
  end
end