module Admin
  class AuthorizedController < ActionController::Base
    before_action :authenticate_user!
    protect_from_forgery with: :exception
    rescue_from Timeout::Error, with: :rescue_from_timeout
    #rescue_from Ptv::ApiError, with: :rescue_from_ptv_error
    layout 'admin'

    include Pundit

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    private

    helper_method def current_company
      @_current_company ||= Company.find_by(id: company_id)
    end

    def company_id
      params[:company_id] || params[:id] || current_user.company
    end

    def user_not_authorized(exception)
      policy_name = exception.policy.class.to_s.underscore

      flash[:error] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
      redirect_to edit_admin_company_path(current_user.company)
    end

     def rescue_from_timeout(exception)
       #TODO Add logic for timeout handling
     end

     def rescue_from_ptv_error(exception)
       #TODO Add logic for ptv_error
     end

  end
end
