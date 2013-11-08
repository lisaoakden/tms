class Course < ActiveRecord::Base
  has_many :enrollments
  has_many :activities,  foreign_key: "course_id", class_name: "Activity"
  has_many :users, through: :enrollments
  has_many :course_subjects
  has_many :subjects, through: :course_subjects
  scope :choose_course, ->course_id {find course_id}
end
