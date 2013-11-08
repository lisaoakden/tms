class Enrollment < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
  
  has_many :conclusions 
  has_many :enrollment_subjects
end