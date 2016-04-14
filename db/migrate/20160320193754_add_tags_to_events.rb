class AddTagsToEvents < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.boolean   :free, :default => false
      t.boolean   :family_friendly, :default => false
      t.boolean   :hike, :default => false
      t.boolean   :play, :default => false
      t.boolean   :learn, :default => false
<<<<<<< HEAD
      t.boolean   :volunteer, :default => false
    end
  end
  def drop
    t.remove :free, :family_friendly, :hike, :play, :learn, :volunteer
=======
      t.boolean   :plant, :default => false
    end
  end
  def drop
    t.remove :free, :family_friendly, :hike, :play, :learn, :plant
>>>>>>> suggest_event_fix
  end
end
