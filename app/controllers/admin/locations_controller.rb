module Admin
  class LocationsController < AuthorizedController
    PER_PAGE = 30

    respond_to :html, :js
    before_action :authorize_current_company

    def index
      query_params =
        PrepareSearchParams.new(
          params,
          'name_or_address_street_or_address_city_cont_any').call
      @q = current_company.locations.ransack(query_params)
      @locations = @q.result.page(params[:page]).per(PER_PAGE)
    end

    def new
      @location = Location.new
      @location.build_address
    end

    def create
      @location = current_company.locations.new(location_params)
      if @location.valid?
        response = create_location_client.call
        if response.success
          @location.ptv_location_id = create_location_client.ptv_location_id
          @location.revision = create_location_client.revision
          @location.save
        else
          flash_error_notice(response)
        end
      end
      respond_with @location, location: admin_company_locations_path(current_company)
    end

    def edit
      @location = load_location
    end

    def update
      load_location
      @location.assign_attributes(checked_location_params)
      check_revision
      if @location.valid? && @check_revision
        response = update_location_client.call
        if response.success
          @location.revision = update_location_client.revision
          @location.save
        else
          flash_error_notice(response)
        end
      elsif @check_revision == false
        flash[:api_error] = t('revision_error_message')
      end
      respond_with @location, location: admin_company_locations_path(current_company)
    end

    def destroy
      load_location
      response = delete_location_client.call
      if response.success
        @location.destroy
      else
        flash_error_notice(response)
      end
      respond_with @location, location: admin_company_locations_path(current_company)
    end

    def refresh_token
      @location = Location.find(params[:id])
      @location.refresh_token(params[:token_type])
    end

    private

    def check_revision
      get_location_client.call
      @check_revision = get_location_client.revision == @location.revision
    end

    def flash_error_notice(response)
      flash[:api_error] =
        response.error_response['error']['responseStatus']['message']
    end

    def get_location_client
      @get_location_client ||= Ptv::GetLocationClient.new(@location)
    end

    def create_location_client
      @create_location_client ||= Ptv::CreateLocationClient.new(@location)
    end

    def update_location_client
      @update_location_client ||= Ptv::UpdateLocationClient.new(@location)
    end

    def delete_location_client
      @delete_location_client ||= Ptv::DeleteLocationClient.new(@location)
    end

    def load_location
      @location ||= current_company.locations.find(params[:id])
    end

    def location_params
      params.require(:location)
        .permit(:name, :longitude, :latitude, :revision,
                custom_fields: [],
                address_attributes: [:street, :number, :city, :zip_code])
    end

    def checked_location_params
      if location_params[:custom_fields].nil?
        location_params.merge(custom_fields: [])
      else
        location_params
      end
    end

    def authorize_current_company
      authorize current_company
    end

    def policy(company)
      CompanyLocationPolicy.new(current_user, company)
    end
  end
end
