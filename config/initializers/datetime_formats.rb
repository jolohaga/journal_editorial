Date::DATE_FORMATS.merge!(
  {
    :datepicker => '%m/%d/%Y',
    :standard_display => '%a, %b %d %Y',
    :short_display => '%Y-%m-%d'
  }
)

Time::DATE_FORMATS.merge!(
  {
    :datepicker => '%m/%d/%Y',
    :standard_display => '%a, %b %d %Y, %I:%M %p',
    :short_display => '%Y-%m-%d %I:%M %p'
  }
)