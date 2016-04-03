class CreateSyncs < ActiveRecord::Migration
  def up
    create_table :syncs do |t|
      t.string    :organization
      t.string    :url
      t.datetime  :last_sync
      t.integer   :calendar_id
      t.timestamps
    end
  end
  
  def down
    drop_table :syncs
  end
end
