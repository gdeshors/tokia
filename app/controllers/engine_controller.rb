# encoding: utf-8

include Process
include EngineHelper

class EngineController < ApplicationController

  TokServer = "tokserver"
  TokClient = "tokclient"
  
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
              @game.log_server = get_file_as_string("/home/#{TokServer}/logs/server.log")
              @game.log_server += get_file_as_string("/home/#{TokServer}/server.err")
              @game.log_a = get_file_as_string("/home/#{TokServer}/logs/client_A.log")
              @game.log_a += get_file_as_string("/home/#{TokServer}/logs/client_A.err")
              @game.log_b = get_file_as_string("/home/#{TokServer}/logs/client_B.log")
              @game.log_b += get_file_as_string("/home/#{TokServer}/logs/client_B.err")
              @game.log_c = get_file_as_string("/home/#{TokServer}/logs/client_C.log")
              @game.log_c += get_file_as_string("/home/#{TokServer}/logs/client_C.err")
              @game.log_d = get_file_as_string("/home/#{TokServer}/logs/client_D.log")
              @game.log_d += get_file_as_string("/home/#{TokServer}/logs/client_D.err")
              winner = find_victorious_team(gamelog)
              if winner == "A"
                @game.winner = @game.ai_1
              end
              if winner == "B"
                @game.winner = @game.ai_2
              end
              @game.save

              # gérer en plus le match
              if PendingGame.first == nil
                match = @game.match
                if match.games[0].winner == match.games[1].winner
                  match.winner = @game.winner 
                end
                 # gérer les elo
                if match.winner != nil
                  match.new_elo_1 = match.ai_1.calculate_new_elo(match.ai_1==match.winner, match.ai_2.elo)
                  match.new_elo_2 = match.ai_2.calculate_new_elo(match.ai_2==match.winner, match.ai_1.elo)
                  match.ai_1.update_attributes(:elo => match.new_elo_1)
                  match.ai_2.update_attributes(:elo => match.new_elo_2)
                else
                  match.new_elo_1 = match.ai_1.elo
                  match.new_elo_2 = match.ai_2.elo
                  match.ai_1.update_attributes(:elo => match.new_elo_1)
                  match.ai_2.update_attributes(:elo => match.new_elo_2)
                end
                match.save
              end
              if @game.winner == nil
                @message = "Ok un match a été enregistré, pas de vainqueur"
              else
                @message = "Ok un match a été enregistré ! team winner = " + @game.winner.name
              end
            end
          else 
            @message = "Le statut de sortie du process était " + $?.exitstatus.to_s
          end
          File.delete(pidFile)

          # s'assurer qu'il n'existe plus de process : pkill -u tokclient, pkill -u tokserver
          system("pkill -u #{TokServer}")
          system("pkill -u #{TokClient}")
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

  def live
    #:line : numéro de ligne après lequel on cherche
    gamelog = "/home/#{TokServer}/logs/game.log"
    render text: get_file_as_string_linemin(gamelog, params[:line].to_i), content_type: "text/plain"
  end

  def get_file_as_string_linemin(filename, lineMin)
    data = ''
    i = 0 
    File.open(filename, "r") do |f| 
      f.each_line do |line|
        if (i >= lineMin)
          #data += i.to_s + " " + line
          data += line
        end
        i+=1
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

    
    pg = PendingGame.first
    if pg == nil

      # choisir les deux IA à lancer (au hasard)
      activeAis = Ai.where(active:true)
      diff = 0
      ais = activeAis.sample(2) # utile sinon plantage...
      ais = activeAis.sample(2) until (ais[0].elo - ais[1].elo).abs < (diff += 100)

      # créer un match
      m = Match.new
      m.ai_1 = ais[0]
      m.ai_2 = ais[1]
      m.save
      # créer deux games avec les joueurs inversés
      g = Game.new
      g.ai_1 = m.ai_1
      g.ai_2 = m.ai_2
      g.match = m
      g.save
      pg = PendingGame.new
      pg.game = g
      pg.save
      g2 = Game.new
      g2.ai_1 = m.ai_2
      g2.ai_2 = m.ai_1
      g2.match = m
      g2.save
      pg2 = PendingGame.new
      pg2.game = g2
      pg2.save
    end
    g = pg.game

    # est-ce que c'est une deuxième partie ?
    lastGame = Game.where("winner_id is not null").last
    cartesFixees = false
    if g.match == lastGame.match
      cartesFixees = true
      open("/home/#{TokServer}/cartes", "w") do |f|
        f.puts extract_cards_from_log(lastGame.gamelog)
      end
    end

     # écrire le fichier properties de lancement
    open("/home/#{TokServer}/server.properties", "w") do |f|
      f.puts "sudo_prefix=sudo su #{TokClient} -c" 
      f.puts "chdir=/home/#{TokServer}"
      f.puts "A=#{g.ai_1.command_line}"
      f.puts "B=#{g.ai_2.command_line}"
      f.puts "C=#{g.ai_1.command_line}"
      f.puts "D=#{g.ai_2.command_line}"
      #si c'est une deuxième partie :
      f.puts "cartes=/home/#{TokServer}/cartes" if cartesFixees
    end
    # write command
    java = "java -cp server/*:env/scala_2.10.3/* net.deshors.tok.server.Server server.properties"
    command = "sudo su #{TokServer} -c '#{java}'"
    pid = Process.spawn(command, :chdir=>"/home/#{TokServer}", :out=>"/home/#{TokServer}/server.out", :err=>"/home/#{TokServer}/server.err")
    open("/home/#{TokServer}/server.pid", 'w') { |f|
      f.puts pid
    }
    return pid
  end

end
