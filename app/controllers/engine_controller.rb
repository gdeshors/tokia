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
            @match = Match.new
            @match.ai_1_id = 1
            @match.ai_2_id = 2
            gamelog = "/home/#{TokServer}/logs/game.log"
            @match.log1 = get_file_as_string(gamelog)
            winner = find_victorious_team(gamelog)
            if winner == "A"
              @match.winner_id = 1
            end
            if winner == "B"
              @match.winner_id = 2
            end
            @match.save

            @message = "Ok un match a été enregistré ! team winner = " + winner.to_s
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
