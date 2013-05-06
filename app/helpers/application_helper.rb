module ApplicationHelper

# Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "GirlsGuild"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def validations?(obj, attribute)
    target = (obj.class == Class) ? obj : obj.class
    return !target.validators_on(attribute).map(&:class).empty?
  end

  def required?(obj, attribute)
    target = (obj.class == Class) ? obj : obj.class
    target.validators_on(attribute).map(&:class).include?(
    ActiveModel::Validations::PresenceValidator)
  end

end
