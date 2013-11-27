class StaticPagesController < ApplicationController
  def home
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
      when '1' ; send_file("/home/tokserver/server/tok-server-1.0-SNAPSHOT.jar")
      when '2' ; send_file("/home/tokserver/env/scala_2.10.3/scala-library-2.10.3.jar")
      when '3' ; send_file("/home/tokserver/env/scala_2.10.3/scala-actors-2.10.3.jar")
      when '4' ; send_file("/home/tokserver/env/scala_2.10.3/log4j-1.2.16.jar")
    end
  end
end
