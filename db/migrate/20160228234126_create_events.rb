class CreateEvents < ActiveRecord::Migration
  def up
    create_table :events do |t|
      t.string    :name, :null => false
      t.string    :organization
      t.text      :description
      t.string    :url
      t.decimal   :cost, :precision => 15, :scale => 2, :default => 0
      t.datetime  :start, :null => false
      t.datetime  :end
      t.text      :how_to_find_us
      t.integer   :meetup_id
      t.string    :status, :default => 'pending'
      t.datetime  :updated
      t.timestamps
    end
  end
  
  def down
    drop_table :events
  end
end
