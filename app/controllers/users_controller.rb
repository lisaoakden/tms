class UsersController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user, only: [:edit, :update]
  before_action :init_user_object

  def show
    enrollment = @user.enrollments.find_by course_id: @user.current_course_id
    @enrollment = @user.enrollments.find_by course_id: @user.current_course_id 
    @activities = current_user.activities.order_desc_created_at
      .paginate page: params[:page], per_page: Settings.items.per_page
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = "Profile updated"
      Activity.user_edit! @user
      redirect_to @user
    else
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit :name, :password, :password_confirmation
  end

  def init_user_object
    @user = User.find params[:id]
  end
  
  def correct_user
    @user = User.find params[:id]
    redirect_to root_url unless current_user? @user
  end 
end