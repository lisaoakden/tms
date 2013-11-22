class Admin::UserListsController < ApplicationController
	include AssignedTrainees
	def show
	end

	def update
		if params[:trainees]
	    course = Course.find params[:course_id]
	    trainees_assigns = User.find params[:trainees]
	    find_assigned_trainees course
	    trainees_unassign = @assigned_trainees - trainees_assigns
    	if course.assign_unassign trainees_assigns, trainees_unassign
		    flash[:success] = "Course trainees updated successfully."
		  else
		  	flash[:error] = "Course trainees updated failed !!"
		  end
	    redirect_to [:admin, current_supervisor, course]
  	end
	end
end