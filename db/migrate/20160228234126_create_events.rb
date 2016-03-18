class CreateEvents < ActiveRecord::Migration
  def up
    create_table :events do |t|
      t.string    :name, null: false
      t.string    :organization
      t.text      :description
      t.string    :url
      t.decimal   :cost, precision: 8, scale: 2, default: 0
      t.string    :venue_name
      t.integer   :st_number
      t.string    :st_name
      t.string    :city
      t.integer   :zip
      t.string    :state, default: 'CA'
      t.string    :country
      t.datetime  :start, null: false
      t.datetime  :end
      t.text      :how_to_find_us
      t.string    :contact_name_first
      t.string    :contact_name_last
      t.string    :contact_phone
      t.string    :contact_email, null: false
      t.integer   :meetup_id
      t.string    :status, default: 'pending', null: false
      t.boolean   :free, default: false, null: false
      t.boolean   :family_friendly, default: false, null: false
      t.boolean   :hike, default: false, null: false
      t.boolean   :play, default: false, null: false
      t.boolean   :learn, default: false, null: false
      t.boolean   :volunteer, default: false, null: false
      t.boolean   :plant, default: false, null: false
      t.datetime  :updated
      t.timestamps
    end
  end
  
  def down
    drop_table :events
  end
end
