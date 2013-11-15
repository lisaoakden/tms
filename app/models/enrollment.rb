class Enrollment < ActiveRecord::Base
  ACTIVATED = 1
  CURRENT_COURSE = 0
  belongs_to :user
  belongs_to :course
  has_many :conclusions 
  has_many :enrollment_subjects
  
  scope :by_course, -> course_id{where course_id: course_id}

  def activated?
		self.status == ACTIVATED
	end
  
  scope :current_enrollment, ->course_id {find course_id}
end