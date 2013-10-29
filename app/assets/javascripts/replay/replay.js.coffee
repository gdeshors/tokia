
log_t = """
A SORT
A FIN
B SORT
B FIN
B DEPLACE B0 A2
B FIN
C SORT
C FIN
C DEPLACE C0 A5
C FIN
A POSE 2
A DEPLACE A0 A2
A MANGE B A2
A FIN
"""
actions_dep = ["SORT", "DEPLACE", "ECHANGE", "MANGE"] 


# FIXME a supprimer : ne sert à rien en théorie
Array::has = (elt) ->
	@indexOf(elt) != -1 
 
write = (t) -> $('body').append "<p>" + t + "</p>"
write "début"



courante = 0




plateau = ""
$ ->
  # gestion du graphique des pions
  log = new Log(log_t)
  Morris.Area({
    element: 'gamechart',
    data: log.data,
    xkey: 'n',
    ykeys: ['A', 'B', 'C', 'D'],
    labels: ['A', 'B', 'C', 'D'],
    lineColors: ["#ff0", "#0d0", "#33f", "#f00"],
    hideHover : true,
    parseTime: false
  })
  plateau = new Board(log)
  plateau.init()

root = exports ? this
root.next = -> plateau.next()
root.prev = -> plateau.prev()

write "fin"

