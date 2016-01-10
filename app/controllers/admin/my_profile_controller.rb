module Admin
  class MyProfileController < AuthorizedController
    respond_to :html

    def edit
    end

    def update
      if current_user.update_with_password(user_params)
        sign_in current_user, bypass: true
        redirect_to admin_my_profile_edit_path
      else
        render "edit"
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :current_password)
    end
  end
end
