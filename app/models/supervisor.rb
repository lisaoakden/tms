class Supervisor < ActiveRecord::Base
	has_many :supervisor_courses
	has_many :courses, through: :supervisor_courses
end
