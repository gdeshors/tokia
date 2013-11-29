# encoding: utf-8

include Process

class EngineController < ApplicationController

  TokServer = "tokserver"
  
  PidFile = "server.pid"

  def run
    # vérifier si un process est en train de tourner
    pidFile = "/home/#{TokServer}/#{PidFile}"
    if File.exist?(pidFile)
      # lire le fichier
      file = File.new(pidFile)
      pid = file.gets.to_i

      begin
        result = waitpid(pid, Process::WNOHANG)
        if result == nil
          # ca tourne encore ; afficher des détails ?
          @message = "Ca tourne encore"
          taille = File.new("/home/#{TokServer}/logs/game.log").size.to_s
          @message += " ; taille du log : " + taille
        else
          # c'est fini !
          # lire et copier les fichiers de log
          # créer un nouveau match
          
          if $?.exitstatus == 0
            pm = PendingGame.first
            if (pm == nil)
              @message = "Aucun match n'était en attente !!"
            else
              @game = pm.game
              pm.destroy # supprimer le pending game
              gamelog = "/home/#{TokServer}/logs/game.log"
              @game.gamelog = get_file_as_string(gamelog)
              winner = find_victorious_team(gamelog)
              if winner == "A"
                @game.winner_id = 1
              end
              if winner == "B"
                @game.winner_id = 2
              end
              @game.save

              # gérer en plus le match
              if PendingGame.first == nil
                match = @game.match
                match.winner = @game.winner # FIXME c'est pas si simple si +ieurs
                 # gérer les elo
                if match.winner != nil
                  match.new_elo_1 = match.ai_1.calculate_new_elo(match.ai_1==match.winner, match.ai_2.elo)
                  match.new_elo_2 = match.ai_2.calculate_new_elo(match.ai_2==match.winner, match.ai_1.elo)
                  match.ai_1.update_attributes(:elo => match.new_elo_1)
                  match.ai_2.update_attributes(:elo => match.new_elo_2)
                end
                match.save
              end
              @message = "Ok un match a été enregistré ! team winner = " + winner.to_s
            end
          else 
            @message = "Le statut de sortie du process était " + $?.exitstatus.to_s
          end
          File.delete(pidFile)
        end
      rescue Errno::ECHILD
        @message = "il n'existait pas de PID " + pid.to_s + " - le fichier pid a été supprimé"
        File.delete(pidFile)
      end
    else
      # lancer un nouveau match
      pid = start_new_game
      @message = "Aucun match n'était en route. Un match a été lancé (pid = " + pid.to_s + ")"
    end
  end


  def get_file_as_string(filename)
    data = ''
    File.open(filename, "r") do |f| 
      f.each_line do |line|
        data += line
      end
    end
    return data
  end

  def find_victorious_team(filename)
    File.open(filename, "r") do |f| 
      f.each_line do |line|
        if line["A VICTOIRE"]
          return "A"
        end
        if line["B VICTOIRE"]
          return "B"
        end
      end
    end
    return nil
  end

  def start_new_game

    if  PendingGame.first == nil
      m = Match.new
      m.ai_1_id = 1
      m.ai_2_id = 2
      m.save
      g = Game.new
      g.ai_1 = m.ai_1
      g.ai_2 = m.ai_2
      g.match= m
      g.save
      pg = PendingGame.new
      pg.game = g
      pg.save
    end
    # write command
    java = "java -cp server/*:env/scala_2.10.3/* net.deshors.tok.server.Server serverSite.properties"
    command = "sudo su tokserver -c '#{java}'"
    pid = Process.spawn(command, :chdir=>'/home/tokserver', :out=>"/home/tokserver/server.out", :err=>"/home/tokserver/server.err")
    open('/home/tokserver/server.pid', 'w') { |f|
      f.puts pid
    }
    return pid
  end

end
