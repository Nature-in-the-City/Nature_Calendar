class User < ActiveRecord::Base
    has_one :contact, :as => :use_type
    accepts_nested_attributes_for :contact
    
    def email
        return self.contact.email
    end
    
    def password= value
        self.encrypted_password = value
    end
end