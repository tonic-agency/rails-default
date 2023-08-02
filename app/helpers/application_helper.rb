module ApplicationHelper

  def page_title
    "My App"
  end

  def page_description
    "My App Description"
  end

  def cache_buster 
    if Rails.env.production?
      ""
    else
      "?stamp=#{DateTime.now.to_s}"
    end
  end

  def disable_left_menu 
    false
  end

end
