class Task < ActiveRecord::Base
	belongs_to :subject
	has_many :customer_courses
end
