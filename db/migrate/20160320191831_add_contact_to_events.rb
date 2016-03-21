class AddContactToEvents < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.string :contact_first, :contact_last, :contact_email
      t.string :contact_phone, :limit => 16
    end
  end
  
  def down
    change_table :events do |t|
      t.remove :contact_first, :contact_last, :contact_phone, :contact_email
    end
  end
end
