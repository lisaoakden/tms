class Admin::SupervisorsController < ApplicationController
  before_action :signed_in_supervisor, only: :show
  before_action :correct_supervisor,   only: [:edit, :update]
  before_action :load_object,          only: [:show, :edit, :update]

  def show
  end

  def edit
  end

  def update
    if @supervisor.update_attributes supervisor_params
      flash[:success] = "Profile updated"
      redirect_to [:admin, @supervisor]
    else
      render :edit
    end
  end

  private
  def load_object
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