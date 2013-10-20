class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from Net::SFTP::StatusException, with: :ssh_exception_hendler

  private

  def ssh_exception_hendler
    redirect_to root_path, alert: 'Sorry, server is experiencing problems with ssh connection, please try again later.'
  end
end
