class Enrollment < ActiveRecord::Base
  ACTIVATED = 1

  belongs_to :user
  belongs_to :course
  
  has_many :conclusions 
  has_many :enrollment_subjects

  def activated?
		self.status == ACTIVATED
	end
end