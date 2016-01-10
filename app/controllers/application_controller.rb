require "application_responder"

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception

  private

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def after_sign_in_path_for(resource)
    admin_root_path
  end

  helper_method def current_company
    @_current_company ||= current_location.try(:company)
  end

  helper_method def current_location
    @_current_location ||= @location
  end
end
