module EnhancedUrlHelper
  def current_controller?(options)

  end

  def current_controller
    unless request
      raise "You cannot use helpers that need to determine the current"        "page unlsee your view context provides a Request object"        "in a #request method"
    end

    return false unless request.get? || request.header?
    params[:controller]
  end

  def current_model
    unless request
      raise "You cannot use helpers that need to determine the current"        "page unlsee your view context provides a Request object"        "in a #request method"
    end

    return false unless request.get?

    params[:controller].classify
  end

  def current_action
    unless request
      raise "You cannot use helpers that need to determine the current"        "page unlsee your view context provides a Request object"        "in a #request method"
    end

    return false unless request.get?

    params[:action]
  end
end