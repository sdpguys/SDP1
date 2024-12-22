class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_notification, only: [:show, :destroy]
  def index
    @notifications = current_user.notifications.order(created_at: :desc)
  end
  def show
    # This will find the notification using the ID from the URL
  end
  def destroy
    @notification.destroy
    redirect_to notifications_path, notice: 'Notification was successfully deleted.'
  end
  private

  def set_notification
    @notification = Notification.find(params[:id])
  end
end
