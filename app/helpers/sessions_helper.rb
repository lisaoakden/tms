module SessionsHelper
  def sign_in user
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user
  end

  def supervisor_sign_in supervisor
    remember_token = Supervisor.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    supervisor.update_attribute(:remember_token, Supervisor.encrypt(remember_token))
    self.current_supervisor = supervisor
  end

  def signed_in?
    current_user.present?
  end

  def supervisor_signed_in?
    current_supervisor.present?
  end

  def current_user= user
    @current_user = user
  end

  def current_supervisor= supervisor
    @current_supervisor = supervisor
  end

  def current_user
    remember_token = User.encrypt cookies[:remember_token]
    @current_user ||= User.find_by remember_token: remember_token
  end

  def current_supervisor
    remember_token = Supervisor.encrypt cookies[:remember_token]
    @current_supervisor ||= Supervisor.find_by remember_token: remember_token
  end

  def current_user? user
    user == current_user
  end

  def current_supervisor? supervisor
    supervisor == current_supervisor
  end

  def signed_in_user
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
    self.current_user = nil
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