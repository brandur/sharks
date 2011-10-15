module ApplicationHelper
  def display_date(date, abbreviated = false)
    cutoff = Date.today - 1.year
    if date > cutoff
      str = "#{distance_of_time_in_words(date, Date.today)} ago"
      str = str.gsub(/about/, '~') if abbreviated
      str
    else
      date.strftime('%b %e, %Y')
    end
  end
end
