# Play a game

$ = jQuery

$.fn.extend
  startGame: (params) ->
    window.mainCanvas = this
    canvas = $(this).get()[0]
    canvas.width = window.innerWidth
    canvas.height = window.innerHeight
    $(window).resize ->
      canvas = $(window.mainCanvas).get()[0]
      canvas.width = window.innerWidth
      canvas.height = window.innerHeight
      gameController.updateBoard()
    initialBoard = game.getInitialBoard(params)
    notify = new game.notifier(this, params)
    window.gameController = new GCAPI.Game(game.asset, params, notify, initialBoard)
    window.uiController = new GCAPI.Ui(gameController)
    uiController.startGame()
    # gameController.startGame()

window.ensureGameFunctions = () ->
  problems = []
  if ! window.game?
    problems.push "You must create a window.game object in your game file"
  else
    if !window.game.getInitialBoard?
      problems.push "You must define a game.getInitialBoard function in your game file"
    if !window.game.notifier?
      problems.push "You must define a game.notifier class in your game file"
  if problems.length > 0
    alert problems.join("\n\n")
    return false
  return true
