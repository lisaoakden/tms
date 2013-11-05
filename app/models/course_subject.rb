class CourseSubject < ActiveRecord::Base
  belongs_to :course
  belongs_to :subject
  has_many :customer_courses
  has_many :tasks, through: :customer_courses 
end
