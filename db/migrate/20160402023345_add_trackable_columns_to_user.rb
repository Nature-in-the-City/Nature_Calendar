class AddTrackableColumnsToUser < ActiveRecord::Migration
  def change
    change_table :users do |t|
      ## Trackable
      t.datetime :remember_created_at
    end
  end
end