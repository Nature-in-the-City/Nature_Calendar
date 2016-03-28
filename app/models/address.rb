class Address < ActiveRecord::Base
    belongs_to :use_type, :polymorphic => true
    
    def street_address
        suffix = ((self.suite_apt)? " ##{self.suite_apt}" : "")
        street = "#{self.st_number} #{self.st_name}#{suffix}"
    end
    
    def city_state_zip
        city_state = "#{self.city}, #{self.state} #{self.zip}"
    end
    
    def full_address
        full = "#{self.street_address}, #{self.city_state_zip}"
    end
    
    def in_radius?(zip, dist)
        puts "TODO: implement radius check"
    end
end