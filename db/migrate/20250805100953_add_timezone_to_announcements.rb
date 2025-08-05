class AddTimezoneToAnnouncements < ActiveRecord::Migration[8.0]
  def change
    add_column :announcements, :timezone, :string
  end
end
