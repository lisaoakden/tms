module Admin::SupervisorsHelper
	def all_supervisors
		Supervisor.all
	end
end