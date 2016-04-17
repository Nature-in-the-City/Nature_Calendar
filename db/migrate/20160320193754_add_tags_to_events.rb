class AddTagsToEvents < ActiveRecord::Migration
  def change
    change_table :events do |t|
      t.boolean   :free, :default => false
      t.boolean   :family_friendly, :default => false
      t.string    :category, :default => "uncategorized"
    end
  end
  def drop
    t.remove :free, :family_friendly, :category
  end
end
