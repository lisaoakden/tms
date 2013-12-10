class Task < ActiveRecord::Base
	belongs_to :subject
	has_many :customer_courses
	has_many :course_subject_tasks
	
	validates :name, presence: true
end