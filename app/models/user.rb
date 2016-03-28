class User < ActiveRecord::Base
    has_one :contact, :as => :use_type
end