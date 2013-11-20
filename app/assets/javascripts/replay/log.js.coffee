class @Log
  constructor: (_log) ->
    numLigne = 0
    numAction = 1
    data = []
    vals = {A: 0, B: 0, C:0, D:0}
    data.push({n:numLigne, A: vals.A, B: vals.B, C: vals.C, D: vals.D})
    dataTermine = []
    valsTermine = {A: 0, B: 0, C:0, D:0}
    dataTermine.push({n:numLigne, A: vals.A, B: vals.B, C: vals.C, D: vals.D})
    this.lines = _log.split("\n")
    actions = [-1] # -1 pour gérer le cas particulier du premier coup
    for line in this.lines
      do (line) =>
        args = line.split(" ")
        if (args[1] is "SORT") then vals[args[2]]++
        if (args[1] is "MANGE") then vals[args[2]]--
        if (args[1] is "TERMINE") 
          valsTermine[args[2]]++
          vals[args[2]]--
        if args[1] is "FIN"
          data.push({n:numAction, A: vals.A, B: vals.B, C: vals.C, D: vals.D})
          dataTermine.push({n:numAction, A: valsTermine.A, B: valsTermine.B, C: valsTermine.C, D: valsTermine.D})
          actions[numAction++] = numLigne
        numLigne++
    this.actions = actions
    $('#total').html(actions.length-1)
    this.data = data
    this.dataTermine = dataTermine

