class @Log
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
        if args[1] is "FIN"
          data.push({n:numAction, A: vals.A, B: vals.B, C: vals.C, D: vals.D})
          actions[numAction++] = numLigne
        numLigne++
    this.actions = actions
    $('#total').html(actions.length-1)
    this.data = data

