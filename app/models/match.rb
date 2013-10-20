class Match < ActiveRecord::Base
  #attr_accessible :ai_1, :ai_2 
  belongs_to :ai_1, :class_name => 'Ai'
  belongs_to :ai_2, :class_name => 'Ai'

  validates :ai_1, presence: true
  validates :ai_2, presence: true
  
end
