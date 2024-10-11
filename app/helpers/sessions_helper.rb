module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  # Returns the current logged-in user (if any).
  def current_user
    if session[:user_id] # means user is logged in
      @current_user ||= User.find_by(id: session[:user_id]) # memoization: check if @current_user is already set, if not, set it to the user found by id
    end
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil? # current_user is not nil
  end

  def log_out
    reset_session
    @current_user = nil
  end
end
