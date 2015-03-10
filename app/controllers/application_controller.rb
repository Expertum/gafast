class ApplicationController < ActionController::Base
  protect_from_forgery
  include Hobo::Controller::AuthenticationSupport
  before_filter :except => [:login, :forgot_password, :accept_invitation, :do_accept_invitation, :reset_password,
:do_reset_password] do
    # Выставляем локаль согласно параметру locale
    I18n.locale = params[:locale]
    #p request
    # отмечаем активность
    logger.info("Session :user => #{session[:user]} #{current_user}");
    User.update(current_user.id, :last_active_at => DateTime.now.utc) if logged_in?

    login_required unless User.count == 0
  end

end
