class EloDataController < ApplicationController
  def history
    matches = []
    lastDate = Match.last.created_at
    (Match.where("winner_id is not null").where(:created_at => (lastDate.to_date - 5)..lastDate.tomorrow)).each do |m|
      matches.push(date: m.created_at, m.ai_1_id => m.new_elo_1, m.ai_2_id => m.new_elo_2 )
    end

    events = []
    event_comments = []
    (Event.where(:created_at => (lastDate.to_date - 5)..(lastDate.to_date + 5))).each do |e|
      events.push(e.created_at)
      event_comments.push(version: e.version, commentaire:e.commentaire )
    end

    fulldata = { 
          :matches => matches,
          :events => events,
          :event_comments => event_comments
    }

    render json: fulldata


  end
end
