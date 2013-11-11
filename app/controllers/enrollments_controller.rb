class EnrollmentsController < ApplicationController
	before_action :signed_in_user, only: [:update]
	before_action :correct_user,   only: [:update]

	def update
		user = User.find params[:user_id], include: :enrollments
    enrollment = user.enrollments.find_by course_id: user.current_course_id
    if params[:activate] == "activate"
    	unless enrollment.blank? || enrollment.activated?
    		enrollment.update_attributes status: Enrollment::ACTIVATED
    		Activity.user_enroll! current_user.id, enrollment.course.id
    		redirect_to root_url
    	end
    end
	end

	private
	def correct_user
    user = User.find params[:user_id]
    redirect_to root_url unless current_user? user
  end 
end