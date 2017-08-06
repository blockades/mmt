module ApplicationHelper

  def flash_notices
    raw([:notice, :error, :alert].map { |type| content_tag('div', flash[type], id: type) unless flash[type].blank?  }.join)
  end

end
