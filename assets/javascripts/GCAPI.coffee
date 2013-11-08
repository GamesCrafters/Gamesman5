# Coffee
window.GCAPI or= {}
window.GCAPI.console = console

window.GCAPI.GameNotifier = class
  constructor: (@canvas, @conf) ->
    @showMoveValues = false
  drawBoard: (board, game) ->
    alert("GameNotifier must implement drawBoard")
  drawMoves: (data, game) ->
    alert("GameNotifier must implement drawMoves")
  setShowMoveValues: (@showMoveValues) ->

reduce = (num, denom) ->
  gcd = (a, b) ->
    return if b then gcd(b, a%b) else a
  d = gcd(num, denom)
  return [num / d, denom / d]

window.GCAPI.getAspectRatio = (p) ->
  dim = game.getDimensions(p)
  return reduce(dim[0], dim[1])

window.GCAPI.Game = class Game
  constructor: (name, parameters, notifierClass, board, @coverCanvas,
                @statusBar, @vvhPanel) ->
    @gameName = name
    @params = parameters
    @notifier = notifierClass
    @previousStates = []
    @nextStates = []
    @currentState =
      board:
        board: board
      moves: []
    @baseUrl = "http://localhost:8081/"
    @showValueMoves = false
    @currentPlayer = 0
    if @params["fake"]
      @fakeIt()
    if game.type == "c"
      @useC()

  fakeIt: () ->
    @baseUrl = "/fake/"

  useC: () ->
    @baseUrl = "http://localhost:8081/"

  isC: () ->
    @baseUrl == "http://localhost:8081/"

  updateSettings: () ->
    @storeGameState()
    here = window.location
    params = here.search
    # Remove "play" replace with "new"
    base = here.origin + here.pathname[...-4] + "new"
    window.location = base + params + "&update-settings=true"

  setDrawProcedure: (draw) ->
    @draw = draw

  getPlayerName: (player = @currentPlayer) ->
    p = 'player' + (player + 1)
    if !!@params[p]
      @params[p]
    else
      'Player ' + (player + 1)

  getPlayerType: (player = @currentPlayer) ->
    n = 'p' + (player + 1) + '-type'
    if !!@params[n]
      @params[n]
    else
      'human'

  getColor: (m, moves) ->
    console.log "getting value for:"
    console.log m
    remoteness =
      win: []
      lose: []
      tie: []
    for move in moves
      if move.value?
        if move.remoteness not in remoteness[move.value]
          remoteness[move.value].push(move.remoteness)
          remoteness[move.value].sort()
          if move.value == "lose"
            remoteness[move.value].reverse()

    r = "0"
    g = "0"
    b = "0"

    if m.value == "win"
      g = "255"
    else if m.value == "tie"
      r = "255"
      g = "255"
    else
      r = "139"
    alpha = ".10"
    console.log remoteness
    remotenesses = remoteness[m.value]
    if remotenesses?
      if remotenesses.indexOf(m.remoteness) == 0
        alpha = "1"
      else if remotenesses.indexOf(m.remoteness) == 1
        alpha = ".5"
    else
      alpha = "0"

    return "rgba(#{r}, #{g}, #{b}, #{alpha})"

  @sortMoves: (moves) ->
    moves.sort (a, b) ->
      if a.value == b.value
        if a.value == "win"
          if a.remoteness < b.remoteness
            return 1
          else if a.remoteness > b.remoteness
            return -1
          else
            return 0
        else
          if a.remoteness < b.remoteness
            return -1
          else if a.remoteness > b.remoteness
            return 1
          else
            return 0
      else
        if a.value == "win"
          return -1
        if b.value == "win"
          return 1
        if a.value == "tie"
          return -1
        if b.value == "tie"
          return 1

  advancePlayer: ->
    @currentPlayer = @nextPlayer()

  nextPlayer: (player = @currentPlayer) ->
    (player + 1) % 2

  getUrlTail: (board) ->
    retval = ""
    if @isC()
      retval = "?"
      for own k,v of @params
        retval += "#{k}=#{v}&"
      retval += "board=" + escape(board)
    else
      retval = ""
      for own k,v of @params
        retval += ";" + k + "=" + v
      retval += ";board=" + escape(board)
    return retval

  getBoardValues: (board, notifier) ->
    requestUrl = @baseUrl + @gameName + "/getMoveValue" + @getUrlTail(board)
    me = @

    if @newBoardData?
      return

    $.ajax requestUrl,
            dataType: "json",
            success: (data) ->
              me.newBoardData = data
              me.finishBoardUpdate()
            error: (data) ->
              console.log ("Get Board Values failed. Trying again")
              setTimeout (-> me.getBoardValues(board, notifier)), 1000

  getPossibleMoves: (board, notifier) ->
    requestUrl = @baseUrl + @gameName + "/getNextMoveValues" + @getUrlTail(board)
    me = @

    if @newMoves?
      return

    $.ajax requestUrl,
            dataType: "json"
            success: (data) ->
              me.newMoves = data
              me.finishBoardUpdate()
            error: (data) ->
              console.log("Get Possible Moves failed. Trying again")
              setTimeout (-> me.getPossibleMoves(board, notifier)), 1000

  playAsComputer: (moves) ->
    moves = GCAPI.Game.sortMoves(moves)
    @makeMove(moves[0]) if moves[0]?

  canUndo: () ->
    @previousStates.length > 0

  undo: () ->
    if @canUndo()
      pcType = @getPlayerType()
      pnType = @getPlayerType(@nextPlayer())
      if pcType == pnType == "computer"
        while @canUndo()
          @advancePlayer()
          @nextStates.push(@currentState)
          @currentState = @previousStates.pop()
      else if pcType == "computer" or pnType == "computer" and @previousBoards.length >= 2
        @nextStates.push(@currentState)
        @nextStates.push(@previousStates.pop())
        @currentState = @previousStates.pop()
      else
        @advancePlayer()
        @nextStates.push(@currentState)
        @currentState = @previousStates.pop()
      @updateBoard()

  canRedo: () ->
    @nextStates.length > 0

  redo: () ->
    if @canRedo()
      @advancePlayer()
      @previousStates.push(@currentState)
      @currentState = @nextStates.pop()
      @updateBoard()

  startGame: () ->
    if @params["continue-game"] == "yes"
      console.log "Restoring..."
      @restoreGameState()
      console.log @currentState
      console.log "Restored"
    @updateBoard()

  makeMove: (move) ->
    GCAPI.console?.log "Player '#{@getPlayerName()}' making move"
    @advancePlayer()
    @previousStates.push(@currentState)
    @nextStates = []
    @currentState =
      board: move
    @updateBoard()

  getMoveHistory: () ->
    retval = []
    for state in @previousStates
      retval.push(state)
    retval.push(@currentState)
    retval

  storeGameState: () ->
    $.cookie("GCAPI-currentState", JSON.stringify(@currentState),
             { path:'/' })
    $.cookie("GCAPI-previousStates", JSON.stringify(@previousStates),
             { path:'/' })
    $.cookie("GCAPI-nextStates", JSON.stringify(@nextStates),
             { path:'/' })

  restoreGameState: () ->
    cs = $.cookie("GCAPI-currentState")
    ps = $.cookie("GCAPI-previousStates")
    ns = $.cookie("GCAPI-nextStates")
    console.log cs
    console.log ps
    console.log ns
    if cs? and ps? and ns?
      @currentState = JSON.parse(cs)
      @previousStates = JSON.parse(ps)
      @nextStates = JSON.parse(ns)

  updateBoard: () ->
    $(@coverCanvas).show()
    $(@notifier.canvas).removeLayers()
    @startBoardUpdate()

  startBoardUpdate: () ->
    @newBoardData = null
    @newMoves = null
    @getBoardValues(@currentState.board.board)
    @getPossibleMoves(@currentState.board.board)

  fixMoves: (moves, me) ->
    fixMove = (m) ->
      if me.isC()
        if m.value == "win"
          m.value = "lose"
        else if m.value == "lose"
          m.value = "win"
      m
    moves = (fixMove(m) for m in moves)
    #console.log moves
    moves

  finishBoardUpdate: () ->
    if !@newBoardData or !@newMoves
      return

    GCAPI.console?.log @newBoardData
    @currentState = {}
    if @newBoardData.status == "ok" and @newMoves.status == "ok"
      @boardData = @newBoardData.response
      @currentState.board = @boardData
      $(@statusBar).html "#{@getPlayerName()} #{@boardData.value} in #{@boardData.remoteness}"

      GCAPI.console?.log "Drawing board state '#{@currentState.board.board}'"
      @notifier.drawBoard(@currentState.board.board, @)

      @currentState.moves = @newMoves.response
      @notifier.drawMoves(@fixMoves(@newMoves.response, @), @)
    else
      alert ( "Request to server failed." )
    @drawVVH()
    if @getPlayerType() == "computer"
      me = @
      call = () ->
        me.playAsComputer(me.newMoves.response) if !!me.newMoves
      setTimeout(call, 500)
    else
      $(@coverCanvas).hide()

  drawVVH: () ->
    drawVVH @vvhPanel, @getMoveHistory()

  getNotifier: () ->
    @notifier

  toggleValueMoves: () ->
    @showValueMoves = !@showValueMoves
    @updateBoard()
    
  drawArrow: (x, y, len, theta) ->
    $("canvas").drawLine({
      fillStyle: "#000",
      x1: x, y1: y,
      x2: x + len/6 * Math.sin(theta), y2: y - len/6 * Math.cos(theta),
      x3: x + 2/3*len * Math.cos(theta) + len/6 * Math.sin(theta), y3: y - len/6 * Math.cos(theta) + 2/3 * len * Math.sin(theta),
      x4: x + 2/3*len*Math.cos(theta) + len/3*Math.sin(theta), y4: y - len/3*Math.cos(theta) + 2/3*len*Math.sin(theta),
      x5: x + len*Math.cos(theta) + len/12*Math.sin(theta), y5: y - len/12*Math.cos(theta) + len*Math.sin(theta), 
      x6: x + 2/3*len*Math.cos(theta) - len/6*Math.sin(theta), y6: y + len/6*Math.cos(theta) + 2/3*len*Math.sin(theta),
      x7: x + 2/3*len*Math.cos(theta), y7: y + 2/3*len*Math.sin(theta),
      x8: x, y8: y
    });

  setup: (callback) ->
    requestUrl = @baseUrl + @gameName + "/getStart"
    me = @
    $.ajax requestUrl,
      dataType: "json"
      success: (data) ->
        console.log data
        if data.status == "ok"
          me.currentState =
            board:
              board: data['response']
            moves: []
          console.log "current state =", me.currentState
          callback()
        else
          me.setup (callback)
      error: (data) ->
        me.setup (callback)
