class SessionsController < ApplicationController 
  def new
  end

  def create
  	trainee = Trainee.active.find_by email: params[:session][:email].downcase
    if trainee && trainee.authenticate(params[:session][:password])
      if (trainee.current_course_id.present?)
        sign_in trainee
        redirect_to root_path
      else
        flash.now[:error] = "You haven't be assigned to any course. You can't access now!"
        render :new
      end
    else
      flash.now[:error] = "Invalid email/password combination"
      render :new
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end