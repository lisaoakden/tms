class Activity < ActiveRecord::Base
	belongs_to :user
	default_scope -> { order('created_at DESC') }
	scope :activities_course, ->course_id,temp_type {where(course_id: course_id).where.not(temp_type: temp_type)}
end