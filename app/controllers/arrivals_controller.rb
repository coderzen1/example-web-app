class ArrivalsController < ApplicationController
  respond_to :js, :html

  def show
    load_location_by_show_token
  end

  def show_vehicles
    load_location_by_show_token
    @arrivals = @location.arrivals
  end

  def index
    # TODO: please fix this
    # @location = Location.find_by!(show_token: params[:token])
  end

  def new
    load_location_by_edit_token
    location_custom_fields
    @arrival = @location.arrivals.new
  end

  def edit
    load_location_by_edit_token
    @arrival = @location.arrivals.find(params[:id])
    @arrival_custom_fields = arrival_custom_fields
  end

  def update
    load_location_by_edit_token
    @arrival = @location.arrivals.find(params[:id])
    @arrival.assign_attributes(arrival_params_for_update)
    return unless @arrival.valid?
    response = update_vehicle_client.call
    @arrival.save if response.success
  end

  def create
    load_location_by_edit_token
    @arrival = @location.arrivals.new(arrival_params)
    if @arrival.valid?
      response = book_vehicle_client.call
      if response.success
        @arrival.scemid = book_vehicle_client.vehicle_scem_id
        @arrival.save
        flash[:scemid] = @arrival.scemid
      else
        error_flash_notice(response)
      end
    end
    respond_with @arrival, location: arrival_new_path(token: @location.edit_token)
  end

  def arrivals_get
    load_location_by_show_token
    client = Ptv::GetArrivalsClient.new(@location)

    if params[:to_page].present?
      response = client.pages(params[:to_page].to_i)
      render json: { response: response }
    else
      response = client.page(params[:page].to_i)
      render json: { response: response }
    end
  end

  private

  def error_flash_notice(response)
    flash[:api_error] =
      response.error_response['error']['responseStatus']['message']
  end

  def book_vehicle_client
    @book_vehicle_client ||= Ptv::CreateArrivalClient.new(@location, @arrival)
  end

  def update_vehicle_client
    @update_vehicle_client ||= Ptv::UpdateArrivalClient.new(@location, @arrival)
  end

  def load_location_by_show_token
    @location ||= Location.find_by!(show_token: params[:token])
  end

  def load_location_by_edit_token
    @location ||= Location.find_by!(edit_token: params[:token])
  end

  def location_custom_fields
    @location_custom_fields ||= @location.custom_fields
  end

  def arrival_custom_fields
    @arrival.custom_fields
  end

  def arrival_params
    params.require(:arrival)
      .permit(:vehicle_type, custom_fields: location_custom_fields)
      .merge(pta: datetime)
  end

  def arrival_params_for_update
    params.require(:arrival)
      .permit(custom_fields: location_custom_fields)
      .merge(pta: datetime)
  end

  def datetime
    date = [
      params[:arrival][:pta][:date],
      params[:arrival][:pta][:time]
    ].join(' ')

    parse_string_to_datetime(date)
  end

  def parse_string_to_datetime(string)
    DateTime.parse(string).utc
  rescue
    nil
  end
end
