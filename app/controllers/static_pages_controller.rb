class StaticPagesController < ApplicationController
  def home
  	@enrollment_subjects =  current_user.enrollment_subjects
  end
end
