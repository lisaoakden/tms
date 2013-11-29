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
end