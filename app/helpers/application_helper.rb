module ApplicationHelper

  def page_title
    "HTML First"
  end

  def page_description
    "Principles to make building web software easier, faster and more inclusive."
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

end
