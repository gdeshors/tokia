class @Gamechart
  
  constructor: (_log, _onClick) ->
    
    Morris.Area({
      element: 'gamechart',
      data: _log.data,
      xkey: 'n',
      ykeys: ['A', 'B', 'C', 'D'],
      labels: ['joueur A', 'joueur B', 'joueur C', 'joueur D'],
      lineColors: ["#ff0", "#0d0", "#33f", "#f00"],
      hideHover : true,
      parseTime: false,
      smooth: true,
      postUnits: " pions",
      pointSize: 0,
      onClick: _onClick
    })

