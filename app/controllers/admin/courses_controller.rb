class Admin::CoursesController < ApplicationController
  layout "admin"
  before_action :signed_in_supervisor,  only: [:show, :index, :update]
  before_action :accessible_course,     only: :show
  before_action :correct_supervisor,    except: [:destroy, :show]
  before_action :load_object,           except: :destroy

  def show
    @course = Course.find params[:id]
  end

  def index
    @courses = current_supervisor.courses.paginate page: params[:page],
      per_page:Settings.items.per_page
  end

  def new
  	@course = Course.new
  	@course.generate_form_data
  end

  def create
  	@course = Course.new course_params
  	if @course.save
      if @supervisor.courses << @course
        flash[:success] = "You have created a new course"
      end
      redirect_to [:admin, @supervisor, @course]
    else
    	render :new
    end
  end

  def edit
    @supervisor = Supervisor.find params[:supervisor_id]
    @course = Course.find params[:id]
  end

  def update
    course = current_supervisor.courses.find params[:id]
    if params[:course]
      if course.update_attributes course_params
        flash[:success] = "#{course.name} has been successfully edited"
      else
        flash[:error] = "Something happen. Course update is failed"
      end
    else
      course.start! unless course.started?
      flash[:success] = "#{course.name} has been successfully started" 
    end
    redirect_to [:admin, current_supervisor, course]
  end

  private
  def load_object
    @supervisor = Supervisor.find params[:supervisor_id]
  end

  def correct_supervisor
    supervisor = Supervisor.find params[:supervisor_id]
    redirect_to root_url unless current_supervisor? supervisor
  end

  def course_params
    params.require(:course).permit :name, :start_date, :end_date,
      course_subjects_attributes: [:id, :course_id, :subject_id, :duration, :chosen,
      course_subject_tasks_attributes: [:id, :course_subject_id, :task_id, :chosen,
        :subject_id]]
  end

  def accessible_course
    supervisor = Supervisor.find params[:supervisor_id]
    unless supervisor.courses.find_by(id: params[:id]) && current_supervisor
      .courses.find_by(id: params[:id])
      redirect_to root_path
    end
  end
end