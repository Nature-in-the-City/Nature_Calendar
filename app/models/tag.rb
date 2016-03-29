class Tag < ActiveRecord::Base
    belongs_to :event
    
    def self.format_valid_tags(tag_object)
        tag_options = %w(family_friendly free play plant hike learn volunteer)
        event_tags = []
        if tag_object
            tag_options.each do |tag|
                event_tags.push(Tag.format_tagname(tag)) if tag_object[tag]
            end
        end
        formatted = event_tags.join(", ")
        return ((formatted.length > 0)? formatted : "None")
    end
    
    def valid_tags
        Tag.format_valid_tags(self)
    end
    
    def has_tag? tag
        tagname = tag.downcase
        tagname = tagname.split("-").join("_")
        return self[tagname]
    end
    
    def self.format_tagname tag
        i = tag.split("_").map &:capitalize
        return i.join("-")
    end
end