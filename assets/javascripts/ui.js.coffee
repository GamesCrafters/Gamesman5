window.GCAPI or= {}

window.GCAPI.Ui = class
  constructor: (@game) ->
  startGame: () ->
    @game.startGame()
