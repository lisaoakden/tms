module SessionsHelper
  def sign_in trainee
    remember_token = Trainee.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    trainee.update_attribute(:remember_token, Trainee.encrypt(remember_token))
    self.current_trainee = trainee
  end

  def supervisor_sign_in supervisor
    remember_token = Supervisor.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    supervisor.update_attribute(:remember_token, Supervisor.encrypt(remember_token))
    self.current_supervisor = supervisor
  end

  def signed_in?
    current_trainee.present?
  end

  def supervisor_signed_in?
    current_supervisor.present?
  end

  def current_trainee= trainee
    @current_trainee = trainee
  end

  def current_supervisor= supervisor
    @current_supervisor = supervisor
  end

  def current_trainee
    remember_token = Trainee.encrypt cookies[:remember_token]
    @current_trainee ||= Trainee.find_by remember_token: remember_token
  end

  def current_supervisor
    remember_token = Supervisor.encrypt cookies[:remember_token]
    @current_supervisor ||= Supervisor.find_by remember_token: remember_token
  end

  def current_trainee? trainee
    trainee == current_trainee
  end

  def current_supervisor? supervisor
    supervisor == current_supervisor
  end

  def signed_in_trainee
    unless signed_in?
      store_location!
      redirect_to signin_url, notice: "Please sign in."
    end
  end

  def signed_in_supervisor
    unless supervisor_signed_in?
      store_location!
      redirect_to admin_signin_url, notice: "Please sign in."
    end
  end

  def sign_out
    self.current_trainee = nil
    cookies.delete :remember_token
  end

  def supervisor_sign_out
    self.current_supervisor = nil
    cookies.delete :remember_token
  end

  def redirect_back_or default
    redirect_to session[:return_to] || default
    session.delete :return_to
  end

  def store_location!
    session[:return_to] = request.url if request.get?
  end
end