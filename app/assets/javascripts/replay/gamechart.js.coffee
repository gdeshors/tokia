class @Gamechart
  
  constructor: (_log) ->
    
    Morris.Area({
      element: 'gamechart',
      data: _log.data,
      xkey: 'n',
      ykeys: ['A', 'B', 'C', 'D'],
      labels: ['A', 'B', 'C', 'D'],
      lineColors: ["#ff0", "#0d0", "#33f", "#f00"],
      hideHover : true,
      parseTime: false,
      smooth: true
    })

