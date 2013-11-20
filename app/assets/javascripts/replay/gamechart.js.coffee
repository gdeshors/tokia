class @Gamechart
  
  constructor: (_log, _onClick) ->
    
    Morris.Line({
      element: 'gamechart',
      data: _log.data,
      xkey: 'n',
      ykeys: ['A', 'B', 'C', 'D'],
      labels: ['joueur A', 'joueur B', 'joueur C', 'joueur D'],
      lineColors: ["#ee0", "#0d0", "#33f", "#f00"],
      hideHover : true,
      parseTime: false,
      smooth: true,
      postUnits: " pions en jeu",
      pointSize: 0,
      onClick: _onClick
    })
    Morris.Line({
      element: 'gamechart2',
      data: _log.dataTermine,
      xkey: 'n',
      ykeys: ['A', 'B', 'C', 'D'],
      labels: ['joueur A', 'joueur B', 'joueur C', 'joueur D'],
      lineColors: ["#ee0", "#0d0", "#33f", "#f00"],
      hideHover : true,
      parseTime: false,
      smooth: true,
      postUnits: " pions terminés",
      pointSize: 0,
      onClick: _onClick
    })

