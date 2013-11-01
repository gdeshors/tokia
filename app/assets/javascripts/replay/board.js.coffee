Array.prototype.remove = (arg) ->
  index = @indexOf(arg)
  @splice(index, 1) unless index is -1


LARGEUR_CASE = 22
HAUTEUR_CASE = 20

anim = '<>'
 


class @Board

  constructor: (_log) ->
    this.paper = Raphael(document.getElementById("board"), 440, 400)
    this.pions = {}
    this.manges = {}
    this.log = _log
    this.cartes = {A:[], B: [], C: [], D: []}
    
  init: ->
    for joueur in ['A', 'B', 'C', 'D']
      do (joueur) =>
        for c in [-4..21]
          do (c) =>
            @drawCase(joueur + c)
    this.drawCase('M')

    # initialiser les pions dans leur écurie 
    for joueur in ['A', 'B', 'C', 'D']
      do (joueur) =>
        for c in [-4..-1]
          do (c) =>
            slot = joueur + c
            new Pawn(this, slot, joueur)
    this.lcourante = 0
    @majCourante()

    #initialiser les cartes
    this.mains = {}
    @mains['A'] = @paper.text(70, 80, "")
    @mains['B'] = @paper.text(335, 90, "")
    @mains['C'] = @paper.text(330, 320, "")
    @mains['D'] = @paper.text(60, 310, "")
    this.tas = @paper.text(220, 170, "")


  xy: (_pos) ->
    [ _pos[0] * LARGEUR_CASE, _pos[1] * HAUTEUR_CASE ]

  position: (val) ->
    return [10, 10] if (val == 'M')
    nval = +val[1..]
    res =  switch
      when nval < 0 then  [1, 7 + nval]
      when nval < 7 then  [1 + nval, 7]
      when nval < 13 then  [8, 14 - nval]
      when nval < 18 then  [nval - 5, 1]
      else [nval - 16, 9]
    switch val[0]
      when 'A' then res
      when 'B' then [20 - res[1], res[0]]
      when 'C' then [20 - res[0], 20 - res[1]]
      when 'D' then [res[1], 20 - res[0]]

  xy_position: (val) ->
    this.xy(this.position(val))
  
  couleur: (j) ->
    switch j
      when 'A' then "#ff0"
      when 'B' then "#0d0"
      when 'C' then "#33f"
      when 'D' then "#f00"
      else '#aaa'

  drawCase: (_pos) ->
    p = this.xy this.position _pos
    circle = @paper.ellipse(p[0], p[1], 10, 9).attr("fill", this.couleur(_pos[0]))
    if (_pos[1] == "-")
      c2 = circle.clone().attr("fill", "000").attr("opacity", "0.7")
   
  prochainPion: (_j) ->
    retour = null
    for i in [-1..-4]
      do (i) =>
        pos = _j + i
        if this.pions[pos]?
          retour = pos
    return retour

  ecurieLibre: (_j) ->
    retour = null
    for i in [-4..-1]
      do (i) =>
        pos = _j + i
        #write pos
        if not this.pions[pos]?
          retour = pos
    return retour

  execute: (args) ->
    #jouer un coup
    #write args
    joueur = args[0]
    switch args[1]
      when 'SORT' then this.pions[this.prochainPion(joueur)].moveTo(joueur + "0", true)
      when 'DEPLACE' then this.pions[args[2]].moveTo(args[3])
      when 'MANGE' then this.mange(args[2], args[3])
      when 'ECHANGE' then this.echange(args[2], args[3])
      when 'PIOCHE' then @pioche(joueur, args[2])
      when 'POSE' then @pose(joueur, args[2])
      when 'JETTE' then @jette(joueur)
    $("#move").append("<p>"+args.join(" ")+"</p>")
      
  undo: (args) ->
    #jouer un coup
    #write args
    joueur = args[0]
    switch args[1]
      when 'SORT' then this.pions[joueur + "0"].moveTo(this.ecurieLibre(joueur))
      when 'DEPLACE' then this.pions[args[3]].moveTo(args[2])
      when 'MANGE' then this.pions[this.prochainPion(args[2])].moveTo(args[3])
      when 'ECHANGE' then this.echange(args[2], args[3])
      when 'PIOCHE' then @depioche(joueur, args[2])
      when 'POSE' then @pioche(joueur, args[2])
    $("#move").append("<p>"+args.join(" ")+"</p>")

  pioche: (_j, _carte) ->
    @cartes[_j].push(_carte)
    @majCartes(_j)
    
  pose: (_j, _carte) ->
    @tas.attr("text", _carte)
    @cartes[_j].remove(_carte)
    @majCartes(_j)

  depioche: (_j, _carte) ->
    @cartes[_j].remove(_carte)
    @majCartes(_j)

  majCartes: (_j) ->
    #mettre à jour toutes les cartes des joueurs en main
    @mains[_j].attr("text", @cartes[_j])

  jette: (_j) ->
    @cartes[_j]=[]
    @majCartes(_j)

  mange: (_j, _pos) ->
    pion = if this.manges[_pos] then this.manges[_pos] else this.pions[_pos]
    if pion.joueur isnt _j then write "ATTENTION BUG #{_j} isnt #{pion.joueur}"
    nouvellePos = this.ecurieLibre(_j)
    #sauvegarder le pion !
    pionMangeur = this.pions[_pos]
    pion.moveTo nouvellePos
    this.pions[nouvellePos] = pion
    this.pions[_pos] = pionMangeur

    
  echange: (_pos1, _pos2) ->
    pion1 = this.pions[_pos1]
    pion2 = this.pions[_pos2]
    pion1.moveTo(this.ecurieLibre(pion1.joueur))
    pion2.moveTo(_pos1)
    pion1.moveTo(_pos2)

  next: ->
    if @lcourante is @log.actions.length - 1 then return
    $("#move").html("")
    $("#move").append("<p><strong>"+"Coup n°" + (@lcourante+1) + "</strong></p>")
    for n in [@log.actions[@lcourante]+1..@log.actions[@lcourante + 1]]
      do (n) =>
        args = @log.lines[n].split(" ")
        @execute(args)
    @lcourante++
    @majCourante()

  prev: ->
    $("#move").html("")
    if @lcourante is 0 then return
    $("#move").append("<p><strong>"+"Coup n°"+@lcourante+" (prochain)</strong></p>")
    for n in [@log.actions[@lcourante - 1]+1..@log.actions[@lcourante]]
      do (n) =>
        args = @log.lines[n].split(" ")
        @undo(args)
    @lcourante--
    @majCourante()


  majCourante: ->
    $('#courante').html(@lcourante)

  gotoMove: (_index) ->
    #alert "play n° " + _index
    if _index > @lcourante
      @next() for i in [@lcourante.._index-1]
    else
      if _index < @lcourante
        @prev() for i in [_index..@lcourante-1]
