class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :show]
  before_action :correct_user,   only: [:edit, :update]
  before_action :load_object,    only: [:show, :edit, :update]

  def show
    @subjects = @user.have_subjects.paginate page: params[:page], per_page: 3
    if signed_in?
      render :show
    else
      redirect_to root_url
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def start_course
    @user = User.find(params[:id], include: :enrollments)
    enrollment = @user.enrollments.choose_current_course(@user.current_course_id).first
    # use .first because at the moment we consider that each trainee only has 1 course
    # in future need to add column current_course :boolean to improve this function
    unless enrollment.activation?
    # need exception to improve but I do not know it yet
      enrollment.toggle! :activation
      enrollment.course.course_subjects.each do |subject|
        subject_name = Subject.find(subject.subject_id).name
        enrollemt_subject = EnrollmentSubject.create(enrollment_id: enrollment.id, 
          status: "new", name: subject_name)    
        subject.custom_courses.each do |t|
          task_name = t.task.name
          EnrollmentTask.create(enrollment_subject_id: enrollemt_subject.id, status: "new", 
            name: task_name)
        end 
      end
    end
    redirect_to @user
  end

  def create
  end

  private
  def user_params
    params.require(:user)
      .permit(:name, :password, :password_confirmation)
  end

  def signed_in_user
    unless signed_in?
      store_location!
      redirect_to signin_url, notice: "Please sign in."
    end
  end

  def correct_user
    @user = User.find params[:id]
    redirect_to root_url unless current_user?(@user)
  end 

  def load_object
    @user = User.find params[:id]
  end
end