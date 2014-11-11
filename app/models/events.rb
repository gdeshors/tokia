class Events < ActiveRecord::Base

  belongs_to :ai, :class_name => 'Ai'

  validates :ai_1, presence: true

end
