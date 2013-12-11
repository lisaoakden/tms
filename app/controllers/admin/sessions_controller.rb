class Admin::SessionsController < ApplicationController
  def new
  end

  def create
  	supervisor = Supervisor.active.find_by email: params[:session][:email].downcase
    if supervisor && supervisor.authenticate(params[:session][:password])
      supervisor_sign_in supervisor
      redirect_to admin_root_path
    else
      flash.now[:error] = "Invalid email/password combination"
      render :new
    end
  end

  def destroy
    supervisor_sign_out
    redirect_to admin_root_path
  end
end