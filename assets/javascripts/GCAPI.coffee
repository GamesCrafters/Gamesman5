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
                @statusBar) ->
    @gameName = name
    @params = parameters
    @notifier = notifierClass
    @previousBoards = []
    @nextBoards = []
    @currentBoard = board
    @baseUrl = "http://nyc.cs.berkeley.edu:8080/gcweb/service/gamesman/puzzles/"
    @showValueMoves = false
    @currentPlayer = 0
    if @params["fake"]
      @fakeIt()

  fakeIt: () ->
    @baseUrl = "/fake/"

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
    if remotenesses.indexOf(m.remoteness) == 0
      alpha = "1"
    else if remotenesses.indexOf(m.remoteness) == 1
      alpha = ".5"

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
    for own k,v of @params
      retval += ";" + k + "=" + v
    retval += ";board=" + escape(board)
    return retval

  getBoardValues: (board, notifier) ->
    requestUrl = @baseUrl + @gameName + "/getMoveValue" + @getUrlTail(board)
    me = @

    $.ajax requestUrl,
            dataType: "json",
            success: (data) ->
              me.newBoardData = data
              me.finishBoardUpdate()

  getPossibleMoves: (board, notifier) ->
    requestUrl = @baseUrl + @gameName + "/getNextMoveValues" + @getUrlTail(board)
    me = @

    $.ajax requestUrl,
            dataType: "json"
            success: (data) ->
              me.newMoves = data
              me.finishBoardUpdate()
            failure: (data) ->
              me.getPossibleMoves(board, notifier)

  playAsComputer: (moves) ->
    bestMove = moves[0]
    for move in moves
      if move.value == bestMove.value
        if move.value == "win" and move.remoteness < bestMove.remoteness
          bestMove = move
        else if move.value != "win" and move.remoteness > bestMove.remoteness
          bestMove = move
      else
        if move.value == "win"
          bestMove = move
        else if move.value == "tie" and bestMove.value == "lose"
          bestMove = move
    @makeMove(bestMove) if !!bestMove

  canUndo: () ->
    @previousBoards.length > 0

  undo: () ->
    if @canUndo()
      pcType = @getPlayerType()
      pnType = @getPlayerType(@nextPlayer())
      if pcType == pnType == "computer"
        while @canUndo()
          @advancePlayer()
          @nextBoards.push(@currentBoard)
          @currentBoard = @previousBoards.pop()
      else if pcType == "computer" or pnType == "computer" and @previousBoards.length >= 2
        @nextBoards.push(@currentBoard)
        @nextBoards.push(@previousBoards.pop())
        @currentBoard = @previousBoards.pop()
      else
        @advancePlayer()
        @nextBoards.push(@currentBoard)
        @currentBoard = @previousBoards.pop()
      @updateBoard()

  canRedo: () ->
    @nextBoards.length > 0

  redo: () ->
    if @canRedo()
      @advancePlayer()
      @previousBoards.push(@currentBoard)
      @currentBoard = @nextBoards.pop()
      @updateBoard()

  startGame: () ->
    @updateBoard()

  makeMove: (move) ->
    GCAPI.console?.log "Player '#{@getPlayerName()}' making move"
    @advancePlayer()
    @previousBoards.push(@currentBoard)
    @nextBoards = []
    @currentBoard = move.board
    @updateBoard()

  updateBoard: () ->
    $(@coverCanvas).show()
    $(@notifier.canvas).removeLayers()
    @startBoardUpdate()

  startBoardUpdate: () ->
    @newBoardData = null
    @newMoves = null
    @getBoardValues(@currentBoard)
    @getPossibleMoves(@currentBoard)

  finishBoardUpdate: () ->
    if !@newBoardData or !@newMoves
      return

    GCAPI.console?.log @newBoardData
    if @newBoardData.status == "ok"
      @boardData = @newBoardData.response
    $(@statusBar).html "#{@getPlayerName()} #{@boardData.value} in #{@boardData.remoteness}"

    GCAPI.console?.log "Drawing board state '#{@currentBoard}'"
    @notifier.drawBoard(@currentBoard, @)
    if @newMoves.status == "ok"
      @notifier.drawMoves(@newMoves.response, @)
    if @getPlayerType() == "computer"
      me = @
      call = () ->
        me.playAsComputer(me.newMoves.response) if !!me.newMoves
      setTimeout(call, 500)
    else
      $(@coverCanvas).hide()

  getNotifier: () ->
    @notifier

  toggleValueMoves: () ->
    @showValueMoves = !@showValueMoves
    @updateBoard()
