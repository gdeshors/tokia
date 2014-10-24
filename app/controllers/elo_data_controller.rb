class EloDataController < ApplicationController
  def history
    data = []
    lastDate = Match.last.created_at
    (Match.where("winner_id is not null").where(:created_at => (lastDate.to_date - 5)..lastDate.tomorrow)).each do |m|
      data.push(date: m.created_at, m.ai_1_id => m.new_elo_1, m.ai_2_id => m.new_elo_2 )
    end

    render json: data
  end
end
