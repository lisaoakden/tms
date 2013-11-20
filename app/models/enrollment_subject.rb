class EnrollmentSubject < ActiveRecord::Base
	DURATION_SUBJECT = 10
	
	belongs_to :enrollment
	belongs_to :subject
	has_many :enrollment_tasks
  has_many :activities, foreign_key: "subject_id", class_name: Activity.name

  accepts_nested_attributes_for :enrollment_tasks
  
  #TODO Hang must change this scope name to make it better, such as "done_subject" or "completed_subject"
  scope :subject_done, ->{where status: "done"}
 
	def finish_subject!
		self.update_attributes! status: "done"
	end

	def done?
		self.status == "done"
	end
end