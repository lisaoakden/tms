class EnrollmentSubject < ActiveRecord::Base
	DURATION_SUBJECT = 10
	has_many :enrollment_tasks
	belongs_to :enrollment
	belongs_to :subject
  has_many :activities, foreign_key: "subject_id", class_name: "Activity"
	def finish_subject!
		self.update_attributes! status: "done"
	end

	def done?
		self.status == "done"
	end
end