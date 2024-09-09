module ApplicationHelper
  include Pagy::Frontend

  def icon_link_to(icon_class, text, url, options = {})
    # Ensure the URL matches exactly
    is_active = request.fullpath.start_with?(url)

    options[:class] = "#{options[:class]} bg-active" if is_active
    link_to url, options do
      concat(content_tag(:i, nil, class: icon_class))
      concat(" #{text}".html_safe)
    end
  end
end
