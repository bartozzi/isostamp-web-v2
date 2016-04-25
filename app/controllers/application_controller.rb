class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :user_signed_in?, :correct_user?
  before_filter :redirect_subdomain

  private

  def current_user
    begin
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    rescue Exception => e
      nil
    end
  end

  def user_signed_in?
    return true if current_user
  end

  def correct_user?
    @user = User.find(params[:id])
    unless current_user == @user || current_user.admin?
      redirect_to root_url, alert: "Access denied."
    end
  end

  def authenticate_user!
    if !current_user
      redirect_to root_url, alert: 'You need to sign in for access to this page.'
    end
  end

  def render_404
    render file: "#{Rails.root}/public/404.html", status: 404
  end

  def redirect_subdomain
    return if Rails.env.test?
    stripped = strip_url(request.host)
    redirect_to "#{stripped}#{request.fullpath}" if stripped != request.host
  end

  def strip_url(url)
    url.sub('https://www.', '').sub('http://www.', '').sub('www.', '')
  end

  def authenticate_admin!
    render_404 if current_user.nil? || !current_user.admin
  end
end

