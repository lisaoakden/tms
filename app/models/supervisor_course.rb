class SupervisorCourse < ActiveRecord::Base
	belongs_to :supervisor_course
	belongs_to :course
end
