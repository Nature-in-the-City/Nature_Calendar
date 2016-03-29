class Contact < ActiveRecord::Base
    belongs_to :use_type, :polymorphic => true

    
    def correct_email_format
        errors.add(:email, 'must provide valid email address') if
            !(email && Contact.valid_email_format?(email) && Contact.valid_email_suffix?(email))
    end
    
    def self.valid_email_format?(address)
        correct_format = /^\w+@\w+\.\w\w\w$/
        address =~ correct_format
    end
    
    def self.valid_email_suffix?(address)
        valid_suffix = %w(.com .net .edu .gov .org .int .mil)
        valid_suffix.any? { |suffix| address.include? suffix }
    end
    
    def format_name
        if self.name_first
            first = name_first.capitalize
            formatted = "#{first}"
            if self.name_last
                last = name_last.capitalize
                formatted = "#{first} #{last}"
            end
            return formatted
        end
        if self.name_last
            return name_last.capitalize
        end
        return ""
    end
end