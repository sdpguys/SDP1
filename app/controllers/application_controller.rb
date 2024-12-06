class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
   before_action :authenticate_user!
  
  allow_browser versions: :modern
 
  # Restrict admin access
  def authenticate_admin!
    redirect_to root_path, alert: 'Not authorized' unless current_user&.admin?
  end
end
