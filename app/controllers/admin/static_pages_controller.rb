class Admin::StaticPagesController < ApplicationController
	layout "admin"
  def dashboard
  	redirect_to admin_signin_path unless supervisor_signed_in? 
  end
end
