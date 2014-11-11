class Event < ActiveRecord::Base

  belongs_to :ai, :class_name => 'Ai'

  validates :ai, presence: true

end
