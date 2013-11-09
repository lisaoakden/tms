class Subject < ActiveRecord::Base
  has_many :course_subjects
  has_many :enrollment_subjects
  has_many :tasks
end
