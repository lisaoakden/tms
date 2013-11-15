class SupervisorCourse < ActiveRecord::Base
	belongs_to :supervisor
	belongs_to :course
end
