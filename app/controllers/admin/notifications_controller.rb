class Admin::NotificationsController < ApplicationController
  before_action :authenticate_admin!  # Ensure only admin can access this page

  def new
    @notification = Notification.new
  end

  def create
    # Collect the parameters for the notification
    notification_params = params.require(:notification).permit(:title, :message)

    if notification_params[:title].present? && notification_params[:message].present?
      # Loop through all users and create a notification for each
      User.find_each do |user|
        # Create a notification for each user, associating it with the user_id
        Notification.create(
          title: notification_params[:title], 
          message: notification_params[:message], 
          user_id: user.id,   # Ensure that the notification is tied to a specific user
          read: false  # Set read status to false for all new notifications
        )
      end
      redirect_to notifications_path, notice: "Notification sent to all users."
    else
      flash[:alert] = "Title and message cannot be blank"
      render :new
    end
  end

  private

  # Use strong parameters to whitelist the input fields
  def notification_params
    params.require(:notification).permit(:title, :message)
  end
end
