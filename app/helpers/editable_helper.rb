module EditableHelper

  def editable_link_to(text, options={})

    #set the editable classes
    if options[:class]
      options[:class] << " editable editable-click"
    else
      options[:class] = "editable editable-click"
    end
    #initialize the data object
    unless options[:data]
      options[:data] = {}
    end

    #set the emptytext
    unless options[:data][:emptytext]
      options[:data][:emptytext] = text
    end

    if options[:resource]
      #set the pk option if the resource exists
      if options[:resource].id
        options[:data][:pk] = options[:resource].id
        #set the url for the resource unless url is already set
        unless options[:data][:url]
          options[:data][:url] = url_for(options[:resource])
        end
      end
      #if the value isn't set yet, add the empty class
      if options[:field] && options[:resource] && !options[:link_text]
        if !options[:resource].send(options[:field]).nil?
          link_text = options[:resource].send(options[:field])
          #special case added for change to age max
          if (options[:field] == :age_max) && (params[:action] != 'edit') && (link_text == 100)
            link_text = 'and Up'
          end
        else
          options[:class] << " editable-empty"
          #add class for required fields
          if required?(options[:resource], options[:field])
            options[:class] << " editable-empty-required"
          end
        end
      end
      options.delete(:resource)
    end
    if options[:field]
      options[:data][:name] = options[:field]
      options.delete(:field)
    end
    if options[:type] && !options[:data][:type]
      options[:data][:type] = options[:type]
    end
    if options[:link_text]
      link_text = options[:link_text]
    end

    unless params[:action] == 'edit'
      if link_text.blank?
        return content_tag(:span, "required", class: 'editable-empty', style: 'font-style: italic')
      else
        return content_tag(:span, link_text)
      end
    end
    return link_to(link_text ||= '', '#', options)
  end

end