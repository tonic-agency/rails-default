module ApplicationHelper

  def page_title
    "Farm Bank"
  end

  def page_description
    "An approach for building web software"
  end

  def cache_buster 
    if Rails.env.production?
      ""
    else
      "?stamp=#{DateTime.now.to_s}"
    end
  end

  def disable_left_menu 
    @disable_left_menu ||= false
  end

  def format_amount(amount, unit = "₱ ")
    # TODO: Add currency based on locale
    return ActionController::Base.helpers.number_to_currency(amount, unit: unit, precision: 2)
  end
end