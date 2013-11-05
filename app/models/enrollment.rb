class Enrollment < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
  has_many :conclusions 
  has_many :enroll_subjects
end
