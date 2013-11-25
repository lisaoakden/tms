module Admin::StaticPagesHelper
	def unassigned_users
		User.choose_user_in_course User::NO_COURSE
	end
end
