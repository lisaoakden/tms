class Admin::TraineesController < ApplicationController
  before_action :signed_in_supervisors, only: :show
  before_action :load_object, only: :show
  
  def show
    @enrollment = @user.enrollments.current_enrollment @user.current_course_id 
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