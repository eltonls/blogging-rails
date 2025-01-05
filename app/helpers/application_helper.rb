module ApplicationHelper
  def show_navbar?
    return false if controller_name == "users" && action_name == "new"

    return false if controller_name == "sessions"

    return true if controller_name == "users" && action_name == "show"

    true
  end
end
