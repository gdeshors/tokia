
log_t = """
S DONNE A R 10 R V
B DEPLACE B-4 A0
B FIN
A DONNE R
A POSE R
A SORT
A MANGE B A0
A FIN
A SORT
A MANGE A A0
A FIN 
B SORT
B FIN
A ECHANGE A0 B0
A FIN
B ECHANGE A0 B0
B FIN
"""
 
actions_dep = ["SORT", "DEPLACE", "ECHANGE", "MANGE"] 
 
Array::has = (elt) ->
	@indexOf(elt) != -1 
 
write = (t) -> $('body').append "<p>" + t + "</p>"
write "début"

class Log
  constructor: (_log) ->  
    numLigne = 0
    numAction = 1
    this.lines = _log.split("\n")
    actions = [0]
    for line in this.lines
      do (line) -> 
        args = line.split(" ")
        actions[numAction++] = numLigne if args[1] == "FIN"
        numLigne++
    this.actions = actions
    $('#total').html(actions.length-1)
log = new Log(log_t)
            
#write log.lines
 
LARGEUR_CASE = 22
HAUTEUR_CASE = 20
 
position = (val) ->
  return [13, 13] if (val == 'M')
  nval = +val[1..]
  res = if nval < 18 then [4 + nval, 4] else 
     switch val[0] 
        when 'A', 'D' then [nval - 13, 6]
        when 'B', 'C' then [nval - 13, 2]
  switch val[0]
    when 'A' then res
    when 'B' then [res[1] + 18, res[0]]
    when 'C' then [26 - res[0], 18 + res[1]]
    when 'D' then [res[1], 26 - res[0]]
    else 'KO'
 
xy = (_pos) ->
  [ (_pos[0] + 1) * LARGEUR_CASE, (_pos[1] + 1) * HAUTEUR_CASE ];
 
paper = Raphael(100, 10, 650, 600)

anim = '<>'
 
couleur = (j) -> 
  switch j
    when 'A' then "#ff0"
    when 'C' then "#33f"
    when 'B' then "#0d0"
    when 'D' then "#f00"
    else '#aaa'
 
class Pawn
  constructor: (_pos, _j, _bloqueur=false) ->
    p = xy position('M')
    pDest = xy position(_pos)
    rx = 8
    ry = 6
    h = 7
    coul = couleur(_j)
    this.joueur = _j
    this.svgSet = paper.set()
    c1 = paper.ellipse(p[0], p[1], rx , ry).attr("fill", coul);
    c2 = paper.rect(p[0] - rx, p[1] - h, 2 * rx, h)
    c2.attr("fill", coul);
    c2.attr("stroke-opacity", "0");
    c3 = paper.ellipse(p[0], p[1] - h, rx, ry);
    c3.attr("fill", coul);
    c4 = c3.clone();
    c4.attr("fill", if (_bloqueur) then "#000" else "#fff");
    c4.attr("opacity", "0.5");
    this.chapeau = c4
    c5 = paper.rect(p[0] - rx, p[1] - h, 0.1, h)
    c6 = paper.rect(p[0] + rx, p[1] - h, 0.1, h)
    this.svgSet.push(c1, c2, c3, c4, c5, c6)
    pions[this.slot] = this
    this.moveTo(_pos, _bloqueur)

    
  moveTo: (_pos, _bloqueur=false) ->
    pions[this.slot] = null 
    p1 = xy position('M')
    p2 = xy position(_pos)
    this.slot = _pos
    this.svgSet.animate( {transform: "t#{p2[0]-p1[0]},#{p2[1]-p1[1]}"}, 1000, anim);
    if (this.bloqueur)
      this.bloqueur = false
      this.chapeau.animate( {fill: "#fff"}, 1000, anim);
    if (_bloqueur)
      this.chapeau.animate( {fill: "#000"}, 1000, anim);
      this.bloqueur = true
    manges[_pos] = pions[_pos] if pions[_pos]?
    #write manges[_pos]
    pions[_pos] = this

 
drawCase = (_pos) ->
  p = xy position _pos
  circle = paper.ellipse(p[0], p[1], 10, 9).attr("fill", couleur(_pos[0]));
  if (_pos[1] == "-") 
    c2 = circle.clone().attr("fill", "000").attr("opacity", "0.7") 
 
 
 
for joueur in ['A', 'B', 'C', 'D']
  do (joueur) ->
    for c in [-4..21]
      do (c) ->
        drawCase(joueur + c)
  drawCase('M')

pions = {}
manges = {}
# initialiser les pions dans leur écurie 
for joueur in ['A', 'B', 'C', 'D']
  do (joueur) ->
    for c in [-4..-1]
      do (c) ->
        slot = joueur + c
        new Pawn(slot, joueur)

prochainPion = (_j) ->
  retour = null
  for i in [-1..-4]
    do (i) ->
      pos = _j + i
      if pions[pos]?
        retour = pos
  return retour

execute = (args) ->
  #jouer un coup
  write args
  joueur = args[0]
  switch args[1]
    when 'SORT' then pions[prochainPion(joueur)].moveTo(joueur + "0", true)
    when 'DEPLACE' then pions[args[2]].moveTo(args[3])
    when 'MANGE' then mange(args[2], args[3])
    when 'ECHANGE' then echange(args[2], args[3])

mange = (_j, _pos) ->
  pion = if manges[_pos] then manges[_pos] else pions[_pos]
  if pion.joueur isnt _j then write "ATTENTION BUG #{_j} isnt #{pion.joueur}"
  nouvellePos = ecurieLibre(_j)
  #sauvegarder le pion !
  pionMangeur = pions[_pos]
  pion.moveTo nouvellePos
  pions[nouvellePos] = pion
  pions[_pos] = pionMangeur

  
echange = (_pos1, _pos2) ->
  pion1 = pions[_pos1]
  pion2 = pions[_pos2]
  pion1.moveTo(ecurieLibre(pion1.joueur))
  pion2.moveTo(_pos1)
  pion1.moveTo(_pos2)


ecurieLibre = (_j) ->
  retour = null
  for i in [-4..-1]
    do (i) ->
      pos = _j + i
      #write pos
      if not pions[pos]?
        retour = pos
  return retour

courante = 0

majCourante = ->
  $('#courante').html(courante)
  
majCourante()

next = () ->
  # lire les lignes de position à position +1 
  # trouver les actions
  # exécuter les actions
  for n in [log.actions[courante]..log.actions[courante+1]]
    do (n) ->
      args = log.lines[n].split(" ")
      execute(args) if actions_dep.has(args[1])
  courante++
  majCourante()



root = exports ? this
root.next = -> next()

write "fin"

