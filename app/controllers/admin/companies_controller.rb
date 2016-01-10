module Admin
  class CompaniesController < AuthorizedController
    respond_to :html

    PER_PAGE = 30

    before_action :authorize_company, except: [:edit, :update]

    def index
      query_params = PrepareSearchParams.new(params, 'name_or_address_street_or_address_city_cont_any').call
      @q = Company.ransack(query_params)
      @companies = @q.result.page(params[:page]).per(PER_PAGE)
    end

    def new
      @company = Company.new.decorate
      @company.build_address
    end

    def create
      @company = Company.create(company_params).decorate
      respond_with @company, location: admin_companies_path
    end

    def edit
      authorize current_company
      @company = current_company.decorate
    end

    def update
      params[:company].delete(:token) if current_user.admin?
      authorize current_company
      @company = current_company.decorate
      @company.update(company_params)
      respond_with current_company, location: admin_companies_path
    end

    def destroy
      current_company.destroy
      respond_with current_company, location: admin_companies_path
    end

    private

    def company_params
      params.require(:company)
        .permit(:name, :logo, :token, :language, dashboard_colors: [],
                address_attributes: [:street, :number, :city, :zip_code])
    end

    def authorize_company
      authorize Company
    end

  end
end
