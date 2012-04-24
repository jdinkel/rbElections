module ApplicationHelper

  # Return a title on a per page basis
  def full_title(page_title)
    base_title = 'Butler County, KS Elections Site'
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  # return a link to the county logo image
  def logo
    image_tag("buco_blk_red_logo1.png", :alt => "Butler County Logo", :class => "logo")
  end
end
