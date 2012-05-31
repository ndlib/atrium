module Atrium::ApplicationHelper
  def thumbnail_class( document )
    display_thumnail( document ) ? ' with-thumbnail' : ''
  end

  def top_level_showcase(exhibit_id)
    showcases = Atrium::Showcase.find_by_atrium_exhibit_id(exhibit_id)
    showcase = showcases.first unless showcases.empty?
  end

  def is_editing?
    session[:edit_showcase].blank? ? false : true
  end

  def get_essay_from_description(desc_hash, desc_id)
    if !desc_hash.nil?
      return desc_hash[desc_id]
    else
      logger.error("hash is blank for some reason. Please check")
      return ""
    end
  end


end
