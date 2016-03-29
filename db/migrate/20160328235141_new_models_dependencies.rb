class NewModelsDependencies < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.references  :use_type, polymorphic:true, index: true
      t.string      :st_name, null: false
      t.integer     :st_number, null: false
      t.string      :city
      t.integer     :apt_suite
      t.string      :state, limit: 2, default: 'CA'
      t.integer     :zip
      t.string      :country, default: 'USA'
      t.string      :venue_name
      t.timestamps  null: false
    end
    
    create_table :contacts do |t|
      t.references  :use_type, polymorphic:true, index: true
      t.string      :name_first
      t.string      :name_last
      t.string      :email, null: false
      t.string      :phone
      t.string      :website
      t.timestamps null: false
    end
    
    create_table :tags do |t|
      t.belongs_to  :event, index: true
      t.boolean     :free, default: false
      t.boolean     :family_friendly, default: false
      t.boolean     :hike, default: false
      t.boolean     :play, default: false
      t.boolean     :learn, default: false
      t.boolean     :volunteer, default: false
      t.boolean     :plant, default: false
      t.timestamps null: false
    end
    
    create_table :event_date_times do |t|
      t.belongs_to  :event, index: true
      t.datetime    :start
      t.datetime    :end
      t.timestamps null: false
    end
  end
  
  def down
    drop_table :tags, :contacts, :addresses, :event_date_times
  end
end
