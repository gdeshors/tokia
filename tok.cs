
log_t = """
A SORT
A FIN
B SORT
B FIN
B DEPLACE B-4 A2
B FIN
C SORT
C FIN
C DEPLACE C-4 A5
C FIN
A POSE 2
A DEPLACE A0 A2
A MANGE B A2
A FIN
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
    data = []
    vals = {A: 0, B: 0, C:0, D:0}
    data.push({n:numLigne, A: vals.A, B: vals.B, C: vals.C, D: vals.D})
    this.lines = _log.split("\n")
    actions = [0]
    for line in this.lines
      do (line) -> 
        args = line.split(" ")
        if (args[1] is "SORT") then vals[args[0]]++
        if (args[1] is "MANGE") then vals[args[2]]--
        numLigne++
        if args[1] is "FIN"
          actions[numAction++] = numLigne 
          data.push({n:numLigne, A: vals.A, B: vals.B, C: vals.C, D: vals.D})
    this.actions = actions
    $('#total').html(actions.length-1)
    this.data = data
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
 
paper = Raphael(40, 40, 650, 600)

anim = '<>'
 
couleur = (j) -> 
  switch j
    when 'A' then "#ff0"
    when 'B' then "#0d0"
    when 'C' then "#33f"
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
    
    
undo = (args) ->
  #jouer un coup
  write args
  joueur = args[0]
  switch args[1]
    when 'SORT' then pions[joueur + "0"].moveTo(ecurieLibre(joueur))
    when 'DEPLACE' then pions[args[3]].moveTo(args[2])
    when 'MANGE' then pions[prochainPion(args[2])].moveTo(args[3])
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
  if courante is log.actions.length - 1 then return
  for n in [log.actions[courante]..log.actions[courante+1]]
    do (n) ->
      args = log.lines[n].split(" ")
      execute(args) if actions_dep.has(args[1])
  courante++
  majCourante()

prev = () ->
  if courante is 0 then return
  for n in [log.actions[courante-1]..log.actions[courante]]
    do (n) ->
      args = log.lines[n].split(" ")
      undo(args) if actions_dep.has(args[1])
  courante--
  majCourante()


# gestion du graphique des pions
Morris.Area({
  element: 'area-example',
  data: log.data,
  xkey: 'n',
  ykeys: ['A', 'B', 'C', 'D'],
  labels: ['A', 'B', 'C', 'D'],
  lineColors: ["#ff0", "#0d0", "#33f", "#f00"]
});
  
  
write "fin"



root = exports ? this
root.next = -> next()
root.prev = -> prev()

write "fin"

