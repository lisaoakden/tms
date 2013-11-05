class Enrollment < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
  has_many :conclusions 
  has_many :enrollment_subjects

  scope :choose_current_course, ->course_id {where(course_id: course_id)}
end