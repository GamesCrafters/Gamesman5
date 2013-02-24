# Coffee
window.GCAPI or= {}

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
  constructor: (name, parameters, notifierClass, board, @coverCanvas) ->
    @gameName = name
    @params = parameters
    @notifier = notifierClass
    @previousBoards = []
    @nextBoards = []
    @currentBoard = board
    @baseUrl = "http://nyc.cs.berkeley.edu:8080/gcweb/service/gamesman/puzzles/"
    @showValueMoves = false
    @currentPlayer = 0

  setDrawProcedure: (draw) ->
    @draw = draw

  getPlayerName: ->
    p = 'player' + (@currentPlayer + 1)
    if !!@params[p]
      @params[p]
    else
      'Player ' + (@currentPlayer + 1)

  getPlayerType: ->
    n = 'p' + (@currentPlayer + 1) + '-type'
    if !!@params[n]
      @params[n]
    else
      'human'

  advancePlayer: ->
    @currentPlayer = (@currentPlayer + 1) % 2

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
      @advancePlayer()
      @nextBoards.push(@currentBoard)
      @currentBoard = @previousBoards.pop()
      if @getPlayerType() == "computer"
        @undo()
      else
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
    @notifier.drawBoard(@currentBoard, @)
    if @newMoves.status == "ok"
      @notifier.drawMoves(@newMoves.response, @)
    $(@coverCanvas).hide()
    if @getPlayerType() == "computer"
      @playAsComputer(@newMoves.response)

  getNotifier: () ->
    @notifier

  toggleValueMoves: () ->
    @showValueMoves = !@showValueMoves
    @updateBoard()
