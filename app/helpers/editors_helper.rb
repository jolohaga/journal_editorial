module EditorsHelper
  def editors_create_path
    @associate.new_record? ? editors_path : editor_path(@submission)
  end
  
  def expertise_display(specializations, options = {})
    line_separator = options[:separator] || "&nbsp;&nbsp;"
    html = "".html_safe
    spec = specializations.group_by(&:category)
    spec.keys.each do |key|
      html += content_tag(:b, :class=> 'min-text') do
        "#{key}: "
      end
      html += content_tag(:i, :class => 'min-text') do
        spec[key].collect{|s| s.name}.join(', ')
      end
      html += "#{line_separator}".html_safe
    end
    html
  end
end