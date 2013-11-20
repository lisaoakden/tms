class Enrollment < ActiveRecord::Base
  ACTIVATED = 1
  UNACTIVATED = 0
  CURRENT_COURSE = 0
  belongs_to :user
  belongs_to :course
  has_many :conclusions 
  has_many :enrollment_subjects
  
  scope :by_enrollment, ->course_id, user_id do 
    where course_id: course_id, user_id: user_id
  end
  
  def activated?
		self.status == ACTIVATED
	end
  
  scope :current_enrollment, -> course_id{where course_id: course_id}

  class << self
    def enroll_course! user, course
      enrolls = by_enrollment  course.id, user.id
      if enrolls.empty?
        Enrollment.create! user_id: user.id, course_id: course.id, 
          status: "new", active_flag: ACTIVATED
      else
        enrolls.map do |enroll|
          enroll.update_attributes! status: "new", active_flag: ACTIVATED
        end
      end
    end

    def enroll_update_active_flag! user, course
      enrolls_update = by_enrollment course.id, user.id
      if enrolls_update.present?
        enrolls_update.map do |enroll_update|
          enroll_update.update_attributes! active_flag: UNACTIVATED
        end         
      end
    end
  end
end