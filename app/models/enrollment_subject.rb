class EnrollmentSubject < ActiveRecord::Base
	DONE = "done"

	belongs_to :enrollment
	belongs_to :subject
	has_many :enrollment_tasks
  has_many :activities, foreign_key: "subject_id", class_name: Activity.name

  accepts_nested_attributes_for :enrollment_tasks
  
  scope :done_subject, ->{where status: DONE}
 
	def finish_subject!
		self.update_attributes! status: DONE
	end

	def done?
		self.status == DONE
	end

	def end_date
		self.start_date + self.subject.duration.day
	end
end