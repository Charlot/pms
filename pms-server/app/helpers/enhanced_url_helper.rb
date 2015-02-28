module EnhancedUrlHelper
  def current_controller?(options)
    unless request
      raise "You cannot use helpers that need to determine the current"        "page unlsee your view context provides a Request object"        "in a #request method"
    end

    return false unless request.get? || request.header?

    url_string = URI.parser.unescape(url_for(options)).force_encoding(Encoding::BINARY)
    url_path = Rails.application.routes.recognize_path(url_string)
    params[:controller] == url_path[:controller]
  end
end