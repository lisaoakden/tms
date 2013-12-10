class Admin::SupervisorsController < ApplicationController
  layout "admin"
  before_action :signed_in_supervisor, only: [:show, :destroy]
  before_action :correct_supervisor, only: [:edit, :update]
  before_action :init_supervisor_object, only: [:edit, :update, :show]

  def show
    #binding.pry
  end

  def edit
  end
  
  def index
    @supervisors = Supervisor.all
     .paginate page: params[:page],
      per_page:Settings.items.per_page
  end

  def update
    if @supervisor.update_attributes supervisor_params
      flash[:success] = "Profile updated"
      redirect_to admin_supervisor_path
    else
      render :edit
    end
  end
  
  def destroy
    supervisor1 = Supervisor.find(params[:id])
    supervisor1.update_attribute(:active_flag, 0)
    flash[:success] = "Supervisor deleted."
    redirect_to admin_supervisors_path
  end
  
  def new
    @supervisor = Supervisor.new
  end
  
  def create
    @supervisor = Supervisor.new(supervisor_params)
    if @supervisor.save
      redirect_to admin_supervisor_path(@supervisor)
    else
      render 'new'
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
    params.require(:supervisor).permit :name, :email, :password, :password_confirmation
  end
  
end