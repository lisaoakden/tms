class CourseSubjectTask < ActiveRecord::Base
	attr_accessor :chosen
	belongs_to :course_subject
	belongs_to :task
end