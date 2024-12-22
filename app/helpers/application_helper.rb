module ApplicationHelper
    def unread_notifications_count(user)
      user.notifications.where(read: false).count
    end
  end
  