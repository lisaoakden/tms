class EnrollmentSubject < ActiveRecord::Base
	has_many :enrollment_tasks
	belongs_to :enrollment
end
