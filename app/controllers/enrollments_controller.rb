class EnrollmentsController < ApplicationController
	before_action :signed_in_user, only: [:update]

	def update
		@user = User.find(params[:id], include: :enrollments)
    	enrollment = @user.enrollments.find_by course_id: @user.current_course_id
    	enrollment.update_attributes(status: 1) unless enrollment.blank? || enrollment_activation?(enrollment)
    	#Enrollment.activate! enrollment unless enrollment.blank? || enrollment.activation?
    	Activity.user_enroll! current_user.id, enrollment.course.id
    	redirect_to root_url
	end
end