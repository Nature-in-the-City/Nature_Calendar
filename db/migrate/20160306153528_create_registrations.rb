class CreateRegistrations < ActiveRecord::Migration
  def up
    create_table :registrations do |t|
      t.integer   :event_id
      t.integer   :guest_id
      t.integer   :invited_guests
      t.datetime  :updated
      t.timestamps
    end
  end
  
  def down
    drop_table :registrations
  end
end
