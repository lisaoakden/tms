class Admin::UserListsController < ApplicationController
	def show
	end

	def update
		if params[:trainees]
	    course = Course.find params[:course_id]
	    trainees_not_in = User.choose_user_not_in_course params[:trainees], 
	    	params[:course_id]
	    trainees = User.choose_user_no_course(course.id)
	    	.find_all_by_id params[:trainees]
    	if trainees_not_in.present?
    		update_enrollment! trainees_not_in, course
    	end
    	if update_trainees! trainees, course
		    flash[:success] = "Course trainees updated successfully."
		  else
		  	flash[:error] = "Course trainees updated failed !!"
		  end
	    redirect_to [:admin, current_supervisor, course]
  	end
	end

	private
	def new_enrollment! trainees, course
		trainees.map do |trainee|
			Enrollment.enroll_course! trainee, course
		end.all?
	end

	def update_trainees! trainees, course
		if new_enrollment! trainees, course
    	trainees.map do |trainee|
    		User.update_coure_id! trainee, course.id
    	end.all?
  	end
  end
  
  def update_enrollment! trainees_not_in, course
  	trainees_not_in.map do |trainee_not_in|
  		Enrollment.enroll_update_active_flag! trainee_not_in, course
  		User.update_coure_id! trainee_not_in, User::NO_COURSE
  	end.all?
  end
end