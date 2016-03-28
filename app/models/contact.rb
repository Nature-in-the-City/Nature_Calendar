class Contact < ActiveRecord::Base
    belongs_to :use_type, :polymorphic => true
end