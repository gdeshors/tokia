# encoding: utf-8
module EngineHelper


  # Prend un log de partie (gamelog) 
  # et retourne une chaîne comprenant toutes les cartes séparées par des espaces ;
  # les paquets sont séparés par des retours chariot.
  # Le dernier paquet n'est pas forcément complet (la partie peut s'arreter en cours).
  def extract_cards_from_log(log)
    mode_nouvellemain = false
    mode_j = 0
    cartes = ""

    log.each_line do |line|
      if line.include? "NOUVELLE_MAIN"
        mode_nouvellemain = true
      end

      if line.include? "POSE J"
        mode_j = 2
      end

      if line.include? "NOUVEAU_PAQUET"
        cartes << "\n" if cartes.length > 0
      end

      if line.include? "PIOCHE"
        if mode_j > 0 or mode_nouvellemain
          cartes << line.split[-1] << " "
        end
      end

      if line.include? "FIN"
        mode_nouvellemain = false if mode_nouvellemain
        mode_j -= 1 if mode_j > 0
      end
    end

    return cartes
  end

end
