class Ai < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true

  has_many :matches_1, :class_name => 'Match', :foreign_key => 'ai_1'
  has_many :matches_2, :class_name => 'Match', :foreign_key => 'ai_2'

  def matches
      Match.where("ai_1_id = ? OR ai_2_id = ?", id, id)
  end

end
