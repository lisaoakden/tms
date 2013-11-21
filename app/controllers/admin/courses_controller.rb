class Admin::CoursesController < ApplicationController
  layout "admin"
	before_action :signed_in_supervisor, only: :show
  before_action :correct_supervisor,   except: :destroy
  before_action :load_object,          except: :destroy

  def show
  	if supervisor_signed_in? 
      @supervisor_course = current_supervisor.supervisor_courses
       .find_by course_id: params[:id]
      @course = Course.find params[:id]
      unless @supervisor_course.course_id == @course.id && 
        current_supervisor?(@supervisor)
        redirect_to root_path
      end     
      @users = User.choose_user_in_course User::NO_COURSE
      @trainees = User.choose_user_in_course @course.id
    end
  end

  def index
    if supervisor_signed_in?
      @courses = current_supervisor.courses.paginate page: params[:page],
        per_page:Settings.items.per_page
    else
      redirect_to root_url
    end
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
    if supervisor_signed_in?
      course = current_supervisor.courses.find params[:id]
      course.start unless course.activated?
      if course.update_attributes course_params
        flash[:success] = "#{course.name} has been successfully edited"
      else
        flash[:error] = "Something happen. Course update is failed"
      end
      redirect_to [:admin, current_supervisor, course]
    else
      redirect_to root_path
    end
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
end