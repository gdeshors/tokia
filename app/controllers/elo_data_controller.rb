class EloDataController < ApplicationController
  def history
    data = []

    (Match.where("winner_id is not null").where(:created_at => (Date.today - 4)..Date.tomorrow)).each do |m|
      data.push(date: m.created_at, m.ai_1_id => m.new_elo_1, m.ai_2_id => m.new_elo_2 )
    end

    render json: data
  end
end
