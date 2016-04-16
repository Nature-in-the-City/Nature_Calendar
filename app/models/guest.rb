class Guest < ActiveRecord::Base
  has_many :registrations
  has_many :events, through: :registrations
  has_many :registrations

  def all_non_anon
    Guest.where(is_anon: false)
  end

  def all_anon
    Guest.where(is_anon: true)
  end

  def self.fields_valid?(fields)
    required_fields = ['first_name', 'last_name', 'email', 'is_anon']
    fields.each do |k, v|
      if (required_fields.include?(k)) and (v == nil || v == '')
        return false
      end
    end
    true
  end

  # Best effort. Meetup names have no specific format
  def self.parse_meetup_name(name)
    name.strip!
    if name.include?(' ')
      return name.split(' ')
    else
      return name, ''
    end
  end

  def self.find_by_meetup_rsvp(rsvp)
    Event.find_by_meetup_id(rsvp[:meetup_id])
  end

  def self.create_by_meetup_rsvp(rsvp)
    first, last = Guest.parse_meetup_name(rsvp[:meetup_name])
    Guest.create!(first_name: first, last_name: last, is_anon: false)
  end
end
