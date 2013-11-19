class Task < ActiveRecord::Base
	ACTIVE = 1
	INACTIVE = 0
	
	belongs_to :subject
	has_many :customer_courses
	has_many :course_subject_tasks
end
