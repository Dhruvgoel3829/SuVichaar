class AddUserIdToAnnouncements < ActiveRecord::Migration[8.0]
  def change
    add_reference :announcements, :user, null: true, foreign_key: true
    
    # If there are existing announcements, you might want to assign them to a default user
    # or handle them differently. For now, we'll leave them with null user_id
    # You can update them later if needed:
    # Announcement.where(user_id: nil).update_all(user_id: User.first.id) if User.exists?
  end
end
