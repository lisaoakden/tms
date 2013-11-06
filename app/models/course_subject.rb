class CourseSubject < ActiveRecord::Base
  belongs_to :course
  belongs_to :subject
  has_many :custom_courses
  has_many :tasks, through: :custom_courses 
end
