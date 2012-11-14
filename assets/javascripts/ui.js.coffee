window.GCAPI or= {}

window.GCAPI.Ui = class
  constructor: (@game, @canvas) ->
  startGame: () ->
    window.GCAPI.mainCanvas = this
    $(window).resize ->
      canvas = $(window.GCAPI.mainCanvas)
    @game.startGame()
