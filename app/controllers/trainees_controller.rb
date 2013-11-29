class TraineesController < ApplicationController
  before_action :signed_in_trainee
  before_action :correct_trainee, only: [:edit, :update]
  before_action :init_trainee_object

  def show
    enrollment = @trainee.enrollments.find_by course_id: @trainee.current_course_id
    @enrollment = @trainee.enrollments.find_by course_id: @trainee.current_course_id 
    @activities = current_trainee.activities.order_desc_created_at
      .paginate page: params[:page], per_page: Settings.items.per_page
  end

  def edit
  end

  def update
    if @trainee.update_attributes trainee_params
      Activity.trainee_edit! @trainee
      flash[:success] = "Profile updated !"
      redirect_to @trainee
    else
      render :edit
    end
  end

  private
  def trainee_params
    params.require(:trainee).permit :name, :password, :password_confirmation
  end

  def init_trainee_object
    @trainee = Trainee.find params[:id]
  end
  
  def correct_trainee
    @trainee = Trainee.find params[:id]
    redirect_to root_url unless current_trainee? @trainee
  end 
end