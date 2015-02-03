class StaticPagesController < ApplicationController
  def home
    #@users = User.paginate(page: params[:page])
    @ykeys = []
    @labels = []
    Ai.all.each do |ai|
     @ykeys.push(ai.id.to_s) 
     @labels.push(ai.name)
    end

    # aller chercher les parties du dernier match
    @games = Match.last

  end

  def rules
  end

  def about
  end

  def contact
  end

  def starterkit
  end

  def download
    case params[:id]
      when '1' ; send_file("/home/tokserver/server/tok-server.jar")
      when '2' ; send_file("/home/tokserver/env/scala_2.10.3/scala-library-2.10.3.jar")
      when '3' ; send_file("/home/tokserver/env/scala_2.10.3/scala-actors-2.10.3.jar")
      when '4' ; send_file("/home/tokserver/env/scala_2.10.3/log4j-1.2.16.jar")
      else render status: 404
    end
  end
end
