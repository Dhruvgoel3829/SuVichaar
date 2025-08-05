class AddNotNullConstraintsToAnnouncements < ActiveRecord::Migration[8.0]
  def change
    change_column_null :announcements, :title, false
    change_column_null :announcements, :posted_on, false
    change_column_null :announcements, :user_id, false
  end
end
