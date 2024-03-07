module ErbvHelper
  # Set an identifier by using the app
  # and component name with the erbv prefix.
  #
  def erbv_id
    "erbv--#{Rails.application.class.module_parent_name.downcase}--#{erbv_name}"
  end

  def erbv_css_container_query_id
    erbv_id
  end

  def erbv_css(skip_auto_css_container: false, container_type: "inline-size", &block)
    return if instance_variable_get(erbv_var("css"))

    instance_variable_set(erbv_var("css"), true)

    unless skip_auto_css_container
      content_for(:erbv_css) do
        content_tag(:style, "#{erbv_component_base_selector} { container: #{erbv_css_container_query_id} / #{container_type}; }")
      end
    end

    content_for(:erbv_css, &block)
  end

  def erbv_js(&block)
    return if instance_variable_get(erbv_var("js"))

    instance_variable_set(erbv_var("js"), true)
    content_for(:erbv_js, &block)
  end

  def erbv_var(postfix)
    "@erbv_#{Rails.application.class.module_parent_name.downcase}_#{erbv_name}_#{postfix}"
  end

  # Creates the container block level element specifically with
  #
  def erbv_html(theme: nil, style: nil, lang: nil, &block)
    theme_class_name = "#{erbv_id} #{theme}".strip

    content_tag(:div, class: theme_class_name, style:, &block)
  end

  # Set the component name by finding the filename from the erb file
  #
  def erbv_name
    caller_locations.each do |location|
      return location.path.split(".").first.split("/").last.sub(/^_/, "") if location&.path&.ends_with?(".html.erb")
    end
  end

  # Defines a top level selector for the component
  #
  def erbv_component_base_selector
    "div.#{erbv_id}"
  end
end
