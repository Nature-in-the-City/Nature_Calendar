class CreateRegistrations < ActiveRecord::Migration
  def up
    create_table :registrations do |t|
      t.belongs_to :event, index: true
      t.belongs_to :guest, index: true
      t.datetime  :updated
      t.timestamps
    end
  end
  
  def down
    drop_table :registrations
  end
end
