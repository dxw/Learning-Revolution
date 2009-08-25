# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def return_to_hidden_field
    hidden_field_tag "return_to", params[:return_to]
  end
  
  def path_for_event(event)
    controller.path_for_event(event)
  end
end
