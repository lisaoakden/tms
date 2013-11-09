class EnrollmentSubjectsController < ApplicationController
	before_action :signed_in_user
	before_action :create_objects, only: [:show, :update]

  def index
    @user = User.find params[:user_id]
    @enrollment = Enrollment.find params[:enrollment_id]
  end

  def show
    @subject = @enrollment_subject.subject
    @enrollment_task = @enrollment_subject.enrollment_tasks
    @activities = current_user.activities.activities_subject @subject.id
  end

  def update
  	complete_all_tasks = true

  	@enrollment_subject.enrollment_tasks.all.each do |task|
  		if task.status != "done"
  			complete_all_tasks = false
  		end
  	end

  	if complete_all_tasks
  		EnrollmentSubject.finish_subject! @enrollment_subject
  		flash[:success] = "Congratulation! You have completed the " + @enrollment_subject.name + " subject"
      Activity.finish_subject! current_user.id, current_user.current_course_id, @enrollment_subject.id
  	else
  		flash[:error] = "You need to complete all tasks before finish subject"
  	end

  	redirect_to user_enrollment_enrollment_subject_path
  end

  private
  def create_objects
  	@user = User.find params[:user_id]
  	@enrollment = Enrollment.find params[:enrollment_id]
  	@enrollment_subject = EnrollmentSubject.find params[:id]
  	unless (current_user?(@user) && current_enrollment?(@enrollment) && 
  		current_subject?(@enrollment_subject) && enrollment_activation?(@enrollment))
  		redirect_to @user
  	end
  end

  def current_enrollment? enrollment
  	current_enrollment = @user.enrollments.find_by course_id: @user.current_course_id
  	enrollment.id == current_enrollment.id
  end

  def current_subject? enrollment_subject
  	enrollment_subject.enrollment_id == @enrollment.id
  end
end