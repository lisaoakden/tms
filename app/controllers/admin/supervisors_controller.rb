class Admin::SupervisorsController < ApplicationController
  layout "admin"
  before_action :signed_in_supervisor, only: :show
  before_action :correct_supervisor, only: [:edit, :update]
  before_action :init_supervisor_object

  def show
  end

  def edit
  end

  def update
    if @supervisor.update_attributes supervisor_params
      flash[:success] = "Profile updated"
      redirect_to admin_supervisor_path
    else
      render :edit
    end
  end

  private
  def init_supervisor_object
    @supervisor = Supervisor.find params[:id]
  end
  
  def correct_supervisor
    supervisor = Supervisor.find params[:id]
    redirect_to root_url unless current_supervisor? supervisor
  end 

  def supervisor_params
    params.require(:supervisor).permit :name, :password, :password_confirmation
  end
end