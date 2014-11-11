class Ai < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true

  has_many :matches_1, :class_name => 'Match', :foreign_key => 'ai_1'
  has_many :matches_2, :class_name => 'Match', :foreign_key => 'ai_2'
  has_many :events, :class_name => 'Event', :foreign_key => 'ai'

  def matches
      Match.where("ai_1_id = ? OR ai_2_id = ?", id, id).order(:id)
  end

  def expected_outcome(elo2)
    1.0/(1 + 10**((elo2 - self.elo)/400.0))
  end

  def calculate_new_elo(victory, elo2)
    score = victory ? 1 : 0
    (self.elo + 30*(score - expected_outcome(elo2))).round
  end

end
