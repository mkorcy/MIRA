class ApplicationController < ActionController::Base
  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end
  # Adds a few additional behaviors into the application controller 
  include Blacklight::Controller

  layout 'blacklight'

  before_filter :authenticate_user!

  # Catch permission errors
  rescue_from Hydra::AccessDenied, CanCan::AccessDenied do |exception|
    if (exception.action == :edit) and current_user.admin?
      redirect_to(catalog_path(params[:id]), :alert => "You do not have sufficient privileges to edit this document.")
    elsif (exception.action == :edit) and current_user.registered?
      redirect_to(contributions_path, :alert => "You do not have sufficient privileges to edit this document.")
    elsif current_user and current_user.persisted?
      redirect_to root_url, :alert => exception.message
    else
      session["user_return_to"] = request.url
      redirect_to new_user_session_url, :alert => exception.message
    end
  end
end
