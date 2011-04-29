module ApplicationHelper

  # Return a title on a per page basis
  def title
    base_title = 'Butler County, KS Elections Site'
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  # return a link to the county logo image
  def logo
    image_tag("buco_blk_red_logo1.png", :alt => "Butler County Logo", :class => "logo")
  end
end
