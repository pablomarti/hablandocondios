class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout :layout_by_resource

  def only_admins
  	if !current_user.is_admin?
  		redirect_to root_path
  	end
  end

  protected
    def layout_by_resource
      if devise_controller?
        "admin"
      else
        if controller_name == "devotionals"
          "admin"
        else
          "application"
        end
      end
    end

end
