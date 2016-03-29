class CreateGuests < ActiveRecord::Migration
  def up
    create_table :guests do |t|
      t.boolean :is_anon
      t.timestamps
    end
  end
  
  def down
    drop_table :guests
  end
end
