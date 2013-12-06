class Admin::TraineesController < ApplicationController
  layout "admin"
  before_action :signed_in_supervisor

  def index
    if params[:course_id]
      course = Course.find params[:course_id]
      @trainees = course.current_trainees
        .paginate page: params[:page], per_page: Settings.items.per_page
    else
      @trainees = Trainee.paginate page: params[:page], 
        per_page: Settings.items.per_page
    end
    @courses = Course.all
  end
  
  def show
    @trainee = Trainee.find params[:id]
    @enrollment = @trainee.current_enrollment
    @course = @trainee.current_course
    @activities = @trainee.activities
      .paginate page: params[:page], per_page: Settings.items.per_page
  end
  
  def new
    @trainee = Trainee.new
  end
  
  def create
    @trainee = Trainee.new(trainee_params)
    if @trainee.save
      sign_in @trainee
      flash[:success] = "Register successful"
      redirect_to admin_trainees_path
    else
      render 'new'
    end
  end
  
  def edit
    @trainee = Trainee.find(params[:id])
  end
  
  def update
    @trainee = Trainee.find params[:id]
    if @trainee.update_attributes trainee_params
      Activity.trainee_edit! @trainee
      flash[:success] = "Profile updated !"
      redirect_to admin_trainee(params[:id])
    else
      render :edit
    end
  end
  
  def destroy
    Trainee.find(params[:id]).destroy
    redirect_to admin_trainees_path
  end
  
  private
    def trainee_params
      params.require(:trainee).permit :name, :password, :password_confirmation, :email
    end
end