class @Pawn

  

  constructor: (_board, _pos, _j, _bloqueur=false) ->
    @anim = "<>"
    @center = _board.xy_position('M')
    this.board = _board
    p = this.board.xy_position('M')
    pDest = this.board.xy_position(_pos)
    rx = 8
    ry = 6
    h = 7
    coul = @board.couleur(_j)
    this.joueur = _j
    this.svgSet = @board.paper.set()
    paper = this.board.paper
    c1 = paper.ellipse(p[0], p[1], rx , ry).attr("fill", coul)
    c2 = paper.rect(p[0] - rx, p[1] - h, 2 * rx, h)
    c2.attr("fill", coul)
    c2.attr("stroke-opacity", "0")
    c3 = paper.ellipse(p[0], p[1] - h, rx, ry)
    c3.attr("fill", coul)
    c4 = c3.clone()
    c4.attr("fill", if (_bloqueur) then "#000" else "#fff")
    c4.attr("opacity", "0.5")
    this.chapeau = c4
    c5 = paper.rect(p[0] - rx, p[1] - h, 0.1, h)
    c6 = paper.rect(p[0] + rx, p[1] - h, 0.1, h)
    this.svgSet.push(c1, c2, c3, c4, c5, c6)
    this.board.pions[this.slot] = this
    this.moveTo(_pos, _bloqueur)

    
  moveTo: (_pos, _bloqueur=false) ->

    # gestion du cas où on annule un termine
    if (@slot? and @slot[1] == '-' and @bloqueur)
      #aller en <j>21
      @board.finis[@slot] = null
      @slot = @joueur + "21"
      @board.pions[@slot] = this


    @board.pions[this.slot] = null
    #p1 = this.board.xy_position('M')
    p2 = this.board.xy_position(_pos)
    this.slot = _pos
    this.svgSet.animate( {transform: "t#{p2[0]-@center[0]},#{p2[1]-@center[1]}"}, 1000, @anim)
    # FIXME mettre une vraie anim
    if (this.bloqueur)
      this.bloqueur = false
      this.chapeau.animate( {fill: "#fff"}, 1000, @anim)
    if (_bloqueur)
      this.chapeau.animate( {fill: "#000"}, 1000, @anim)
      this.bloqueur = true
    this.board.manges[_pos] = this.board.pions[_pos] if this.board.pions[_pos]?
    this.board.pions[_pos] = this

    # gestion du cas où on termine
    if (_pos[1..] == "21")
      @board.pions[_pos] = null
      # rendre bloqueur
      @bloqueur = true
      @chapeau.animate( {fill: "#000"}, 1000, @anim)
      # et aller à l'écurie
      @slot = @board.ecurieLibrePionFini(@joueur)
      @board.finis[@slot] = this
      p3 = this.board.xy_position(@slot)
      @svgSet.animate( {transform: "t#{p3[0]-@center[0]},#{p3[1]-@center[1]}"}, 3000, "bounce")



