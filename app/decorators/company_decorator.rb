class CompanyDecorator < Draper::Decorator
  delegate_all
  def logo_image
    if object.logo?
      h.image_tag object.logo.url, class: "form-input__field form-input__field--expanded-board-square logo-image"
    else
      h.image_tag '', class: "form-input__field form-input__field--expanded-board-square logo-image"
    end
  end
end
