module Admin::StaticPagesHelper
	def unassigned_users
		User.choose_user_in_course nil
	end
end
