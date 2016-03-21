class AddLocationToEvents < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.string    :venue_name
      t.integer   :st_number
      t.string    :st_name
      t.string    :city
      t.integer   :zip
      t.string    :state, :limit => 2, :default => 'CA'
      t.string    :country, :default => 'USA'
    end
  end
  def drop
    change_table :events do |t|
      t.remove    :venue_name, :st_number, :st_name, :city, :zip, :state, :country
    end
  end
end
