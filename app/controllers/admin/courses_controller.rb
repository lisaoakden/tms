class Admin::CoursesController < ApplicationController
  layout "admin"
  before_action :signed_in_supervisor, only: [:show, :update, :index]
  before_action :accessible_course, only: [:show, :update, :destroy]
  before_action :correct_supervisor, except: :show

  def show
    @course = Course.active.find params[:id]
  end

  def index
    @courses = current_supervisor.courses.active.paginate page: params[:page], 
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
    @course = Course.active.find params[:id]
  end

  def update
    course = current_supervisor.courses.active.find params[:id]
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
    @course = Course.active.find(params[:id])
    @course.update_attribute(:active_flag, 0)
    @supervisorCourse = @course.supervisor_courses.find_by_supervisor_id(params[:supervisor_id])
    @supervisorCourse.active_flag = 0
    @course.enrollments.each do |enrollment|
      enrollment.update_attribute(:active_flag, 0)
      enrollment.enrollment_subjects.each do |enrollment_subject|
        enrollment_subject.update_attribute(:active_flag, 0)
        enrollment_subject.enrollment_tasks.each do |enrollment_task|
          enrollment_task.update_attribute(:active_flag, 0)
        end
      end
    end
    @course.course_subjects.each do |course_subject|
      course_subject.update_attribute(:active_flag, 0)
      course_subject.course_subject_tasks.each do |course_subject_tasks|
        course_subject_tasks.update_attribute(:active_flag, 0)
      end
    end
    @supervisorCourse.save
    @course.save
    redirect_to admin_supervisor_courses_path(params[:supervisor_id])
  end

  private
  def correct_supervisor
    supervisor = Supervisor.active.find params[:supervisor_id]
    redirect_to root_url unless current_supervisor? supervisor
  end

  def course_params
    params.require(:course).permit :name, :start_date, :end_date,
      course_subjects_attributes: [:id, :course_id, :subject_id, :duration,
        :start_date, :active_flag, course_subject_tasks_attributes: [:id, 
          :course_subject_id, :task_id, :subject_id, :active_flag]]
  end

  def accessible_course
    supervisor = Supervisor.active.find params[:supervisor_id]
    unless supervisor.courses.find_by(id: params[:id]) && current_supervisor
      .courses.find_by(id: params[:id])
      redirect_to root_path
    end
  end
end