class ActivitiesController < ApplicationController
  def new
  end
  
  def show
  	@activities = current_user.activities.order_desc_created_at
  	if signed_in?
  		render :show
  	else
      redirect_to root_url
  	end
  end
end
