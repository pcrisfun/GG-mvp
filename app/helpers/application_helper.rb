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

  def nice_url(url_str)
    if url_str.starts_with?('http://')
      return url_str
    elsif url_str.starts_with?('https://')
      return url_str
    else
      return 'http://' + url_str
    end
  end

end
