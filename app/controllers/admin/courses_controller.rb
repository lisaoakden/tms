class Admin::CoursesController < ApplicationController
  before_action :choose_course, only: [:show, :index]
  before_action :correct_supervisor, only: [:update]

  def update
    if supervisor_signed_in?
      @course = current_supervisor.courses.find params[:id]
      unless @course.activated?
        @course.update_attributes status: "start"
      end
      redirect_to admin_supervisor_course_path(current_supervisor.id, @course.id)
    else
      redirect_to root_path
    end
  end

  def show
  	if supervisor_signed_in? 
      @course = current_supervisor.courses.find params[:id]
      @enrollment_subject = EnrollmentSubject.find params[:id]
      @enrollment_task = EnrollmentTask.find params[:id]
      unless @supervisor_courses.course_id == @course.id && 
        current_supervisor?(@supervisor)
        redirect_to root_path
      end
  	else
  		redirect_to root_path
  	end
  end

  def index
    if supervisor_signed_in?
      @courses = @supervisor.courses.paginate page: params[:page],
        per_page:Settings.items.per_page
    else
      redirect_to root_url
    end
  end

  private
  def correct_supervisor
    supervisor = Supervisor.find params[:supervisor_id]
    redirect_to root_url unless current_supervisor? supervisor
  end 

  def choose_course
    @supervisor = Supervisor.find params[:supervisor_id]
    @supervisor_courses = current_supervisor.supervisor_courses
      .find params[:id]
  end
end