module ApplicationHelper
  def table_for(object, options = {}, &block)
    #style = options[:style] || ""
    #id = options[:id] || ''
    content_tag(:table, options.merge({:class => 'table-for'}), &block)
  end

  def upload_form_for(options = {})
    object = options[:object]
    action = options[:action]
    placement = options[:place_block]
    html = ''.html_safe
    form_for(object, :url => action, :html => {:multipart => true, :method => :post}) do |f|
      if block_given? && placement == :before
        html << content_tag(:p) do
          yield(f)
        end
      end
      html << content_tag(:span) do
        f.label :upload_files
      end
      html << file_field_tag('upload_data[]', :multiple => 'true') + "<br/>".html_safe
      html << content_tag(:div, '', :id => 'selected-files')
      if block_given? && placement == :after
        html << content_tag(:p) do
          yield(f)
        end
      end
      html << content_tag(:p, f.submit("Upload"))
    end
  end
end