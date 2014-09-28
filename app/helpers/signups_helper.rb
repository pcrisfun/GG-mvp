module SignupsHelper

  def get_formated_date(date, args = {})
    unless date
      return nil
    end
    unless args[:format]
      return date.strftime('%B %e, %Y')
    end
    return date.strftime(args[:format])
  end

end
