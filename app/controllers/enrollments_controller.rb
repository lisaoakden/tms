class EnrollmentsController < ApplicationController
	before_action :signed_in_user, only: [:update]

	def update
		@user = User.find(params[:id], include: :enrollments)
    enrollment = @user.enrollments.find_by course_id: @user.current_course_id
    Enrollment.activate! enrollment unless enrollment.blank? || enrollment.activation?
    redirect_to root_url
	end
end