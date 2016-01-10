module Admin
  class UsersController < AuthorizedController
    respond_to :html

    PER_PAGE = 30

    before_action :authorize_user

    def index
      @q = current_company.users.ransack(params[:q])
      @users = @q.result.page(params[:page]).per(PER_PAGE)
    end

    def new
      @user = User.new
    end

    def create
      @user = current_company.users.invite!(user_params.merge(role: :admin))
      respond_with @user, location: admin_company_users_path(current_company)
    end

    def edit
      @user = load_user
    end

    def update
      @user = load_user
      @user.update(user_params)
      respond_with @user, location: admin_company_users_path(current_company)
    end

    def toggle_activation
      user = load_user
      user.toggle(:active)
      user.save
      redirect_to admin_company_users_path(current_company)
    end

    def destroy
      load_user.destroy
      redirect_to admin_company_users_path(current_company)
    end

    private

    def user_params
      params.require(:user).permit(:email, :company_id, :active)
    end

    def load_user
      current_company.users.find(params[:id])
    end

    def authorize_user
      authorize current_user
    end
  end
end
