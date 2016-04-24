class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string    :email, null: false
      t.string    :name, default: 'John Doe', null: false
      t.string    :encrypted_password, default: '', null: false
      t.string    :reset_password_token
      t.datetime  :reset_password_sent_at
      t.integer   :failed_attempts, default: 0, null: false
      t.boolean   :level, default: false, null: false
      t.datetime  :locked_at
      t.datetime  :remember_created_at
      t.timestamps
    end
  end
  
  def down
    drop_table :users
  end
end
