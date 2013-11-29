class EnrollmentsController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user, only: :update

	def update
		user = User.find params[:user_id], include: :enrollments
    enrollment = user.enrollments.find_by course_id: user.current_course_id
    if params[:activate] == "activate"
    	unless enrollment.blank? || enrollment.activated?
    		enrollment.update_attributes status: Settings.status.started
        Activity.user_enroll! enrollment
    		redirect_to root_url
    	end
    end
	end

  def show
    @enrollment = current_user.enrollments
      .find_by course_id: current_user.current_course_id
    @enrollment_subjects = @enrollment.enrollment_subjects 
    @activities = current_user.activities.order_desc_created_at
      .activities_course(current_user.current_course_id, Activity::EDIT_PROFILE)
      .paginate(page: params[:page], per_page: Settings.items.per_page)
    @course = @enrollment.course
  end

	private
	def correct_user
    user = User.find params[:user_id]
    redirect_to root_url unless current_user? user
  end 
end