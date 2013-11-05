class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update, :show]
  before_action :correct_user,   only: [:edit, :update]
  before_action :load_object,    only: [:show, :edit, :update]

  def show
    @subjects = @user.have_subjects.paginate page: params[:page], per_page: 3
    @activities = current_user.activities
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
      user_edit(@user.id)
      redirect_to @user

    else
      render :edit
    end
  end

  def activate
    @user = User.find(params[:id], include: :enrollments)
    enrollment = @user.enrollments.choose_current_course(@user.current_course_id).first
    unless enrollment.blank? || enrollment.activation?
    # use .first because at the moment we consider that each trainee only has 1 course
    # in future need to add column current_course :boolean to improve this function
    user_enroll(@user.id,enrollment.course_id)
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

  def start_course

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

  def load_object
    @user = User.find params[:id]
  end
  def correct_user
    @user = User.find params[:id]
    redirect_to root_url unless current_user? @user
  end 

  def user_enroll user_id,course_id
    Activity.create! user_id: user_id,course_id: course_id, temp_type: 1
  end

  def user_edit user_id
    Activity.create! user_id: user_id, temp_type: 2
  end
end
