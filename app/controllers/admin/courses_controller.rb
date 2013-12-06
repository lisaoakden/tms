class Admin::CoursesController < ApplicationController
  layout "admin"
  before_action :signed_in_supervisor, only: [:show, :update, :index]
  before_action :accessible_course, only: [:show, :update, :destroy]
  before_action :correct_supervisor, except: :show

  def show
    @course = Course.find params[:id]
  end

  def index
    @courses = current_supervisor.courses.paginate page: params[:page], 
      conditions: "supervisor_courses.active_flag = 1",
      per_page:Settings.items.per_page
  end

  def new
    @course = Course.new
  end

  def create
    @course = Course.new course_params
    if @course.save
      if current_supervisor.courses << @course
        flash[:success] = "You have created a new course"
      end
      redirect_to admin_supervisor_course_path current_supervisor, @course
    else
      render :new
    end
  end

  def edit
    @course = Course.find params[:id]
  end

  def update
    course = current_supervisor.courses.find params[:id]
    if params[:course]
      if course.update_attributes course_params
        flash[:success] = "#{course.name} has been successfully edited"
        redirect_to admin_supervisor_course_path current_supervisor, course
      else
        flash[:error] = "Course update failed. Please try again"
        @course = Course.find params[:id]
        render :edit
      end
    elsif params[:start] == Settings.action.course.start
      course.start! unless course.started?
      flash[:success] = "#{course.name} has been successfully started"
      redirect_to admin_supervisor_course_path current_supervisor, course
    elsif params[:finish] == Settings.action.course.finish
      course.finish! unless course.finished?
      flash[:success] = "#{course.name} has been successfully finished"
      redirect_to admin_supervisor_course_path current_supervisor, course
    end
  end
  
  def destroy
    course = Course.find(params[:id])
    course.save if course.delete! params[:supervisor_id]
    redirect_to admin_supervisor_courses_path(params[:supervisor_id])
  end

  private
  def correct_supervisor
    supervisor = Supervisor.find params[:supervisor_id]
    redirect_to root_url unless current_supervisor? supervisor
  end

  def course_params
    params.require(:course).permit :name, :start_date, :end_date,
      course_subjects_attributes: [:id, :course_id, :subject_id, :duration,
        :start_date, :active_flag, course_subject_tasks_attributes: [:id, 
          :course_subject_id, :task_id, :subject_id, :active_flag]]
  end

  def accessible_course
    supervisor = Supervisor.find params[:supervisor_id]
    unless supervisor.courses.find_by(id: params[:id]) && current_supervisor
      .courses.find_by(id: params[:id])
      redirect_to root_path
    end
  end
end