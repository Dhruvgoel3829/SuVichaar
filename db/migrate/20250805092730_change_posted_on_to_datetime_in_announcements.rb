class ChangePostedOnToDatetimeInAnnouncements < ActiveRecord::Migration[8.0]
  def change
    change_column :announcements, :posted_on, :datetime
  end
end
