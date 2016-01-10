class UiTheme
  attr_reader :text_dark, :background_dark, :text_medium, :background_medium,
              :text_light, :background_light, :background_primary, :dashboard_color

  def initialize(current_company)
    @current_company = current_company
    initialize_theme_colors
  end

  private

  def initialize_theme_colors
    @background_primary = '#E5EAF0'

    if @current_company.present?
      @text_dark = company_dashboard_colors[0]
      @background_dark = company_dashboard_colors[0]
      @text_medium = company_dashboard_colors[1]
      @background_medium = company_dashboard_colors[1]
      @text_light = company_dashboard_colors[2]
      @background_light = company_dashboard_colors[2]
      @dashboard_color = company_dashboard_colors[0]

    else
      @text_dark = '#E31D1F'
      @background_dark = '#E31D1F'
      @text_medium = '#FF8080'
      @background_medium = '#FF8080'
      @text_light = '#FFFFFF'
      @background_light = '#FF4040'
      @dashboard_color = '#E31D1F'
    end
  end

  def company_dashboard_colors
    @company_dashboard_colors ||= @current_company.dashboard_colors
  end
end
