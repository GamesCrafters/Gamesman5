# Play a game

$ = jQuery

$.fn.extend
  startGame: (params) ->
    this.html("<canvas id='GCAPI-main' /><canvas id='GCAPI-control' />")
    window.mainCanvas = document.getElementById('GCAPI-main')
    window.controlPanel = document.getElementById('GCAPI-control')
    $(mainCanvas).css('display', 'block')
    $(mainCanvas).css('position', 'absolute')
    $(controlPanel).css('display', 'block')
    $(controlPanel).css('position', 'absolute')
    $(controlPanel).css('left', '0px')
    $(this).css('width', window.innerWidth)
    $(this).css('height', window.innerHeight)
    console.log GCAPI.getAspectRatio(params)
    initialBoard = game.getInitialBoard(params)
    notify = new game.notifier($(mainCanvas), params)
    window.gameController = new GCAPI.Game(game.asset, params, notify, initialBoard)
    window.uiController = new GCAPI.Ui(gameController, mainCanvas,
                                       controlPanel, this, 
                                       GCAPI.getAspectRatio(params))
    uiController.startGame()

window.ensureGameFunctions = () ->
  problems = []
  if ! window.game?
    problems.push "You must create a window.game object in your game file"
  else
    if !window.game.getDimensions?
      problems.push "You must define a game.getDimensions function in your game file"
    if !window.game.getInitialBoard?
      problems.push "You must define a game.getInitialBoard function in your game file"
    if !window.game.notifier?
      problems.push "You must define a game.notifier class in your game file"
  if problems.length > 0
    alert problems.join("\n\n")
    return false
  return true
