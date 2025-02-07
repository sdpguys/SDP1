class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
   before_action :authenticate_user!
   protect_from_forgery with: :exception
  allow_browser versions: :modern
 


  
  def authenticate_admin!
    redirect_to root_path, alert: 'Not authorized' unless current_user&.admin?
  end
  
end
