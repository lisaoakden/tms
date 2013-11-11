class EnrollmentSubject < ActiveRecord::Base
	has_many :enrollment_tasks
	has_many :activities, foreign_key: "subject_id", class_name: "Activity"
	belongs_to :enrollment
	belongs_to :subject

	def finish_subject!
		self.update_attributes! status: "done"
	end
end