module ApplicationHelper

  def nav_button_class(button_path)
    if request.path.include?(button_path)
      'u-background-dark u-text-light'
    end
  end

  def nav_item_class(item_path)
    if request.fullpath == item_path
      'nav-dropdown__menu-item--italic'
    end
  end

  def inline_svg(image_path, options = {})
    file = File.read(Rails.root.join('app', 'assets', 'images', image_path))
    doc = Nokogiri::HTML::DocumentFragment.parse(file)
    svg = doc.at_css('svg')
    svg['class'] = options[:class] if options[:class].present?
    doc.to_html.html_safe
  end

  def show_company_nav?
    controller_name == 'users' || controller_name == 'locations'
  end

  def header_nav_location_title
    if controller_name == 'arrivals'
      current_location.name
    else
      t("header_company_pick_location")
    end
  end

  def hide_navigation?
    user_signed_in? == false && controller_name == 'arrivals' && action_name == 'new'
  end
end
