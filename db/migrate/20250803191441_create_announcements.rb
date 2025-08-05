class CreateAnnouncements < ActiveRecord::Migration[8.0]
  def change
    create_table :announcements do |t|
      t.string :title
      t.text :content
      t.date :posted_on
      t.string :created_by

      t.timestamps
    end
  end
end
