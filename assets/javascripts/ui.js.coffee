window.GCAPI or= {}

window.GCAPI.Ui = class
  constructor: (@game, @canvas, @controlPanel, @bg, @ratio) ->

  resizeBG: ->
    @bg.css('width', window.innerWidth)
    @bg.css('height', window.innerHeight)

  resizeCanvas: ->
    hpad = ((window.innerHeight / 1.5 / 6) + 10) * 2
    padding = 50
    wid1 = window.innerWidth - hpad
    hei1 = (wid1 / @ratio[0]) * @ratio[1]

    hei2 = window.innerHeight - 50
    wid2 = (hei2 / @ratio[1]) * @ratio[0]

    if hei1 <= window.innerHeight - 50
      @canvas.width = wid1
      @canvas.height = hei1
    else
      @canvas.width = wid2
      @canvas.height = hei2
    $(@canvas).css('top', (window.innerHeight / 2) - (@canvas.height / 2))
    $(@canvas).css('left', (window.innerWidth / 2) - (@canvas.width / 2))
    @game.updateBoard()

  resizeControl: ->
    me = this
    h = window.innerHeight / 1.5
    w = h / 6
    @controlPanel.width = w
    @controlPanel.height = h
    $(@controlPanel).css('top', (window.innerHeight / 2) - (h / 2))

    console.log "redrawing control panel"

    $(@controlPanel).drawRect
      layer: true
      fillStyle: "#000"
      fromCenter: false
      x: 0, y: 0
      width: w
      height: h

    $(@controlPanel).drawRect
      fillStyle: "#F00"
      fromCenter: false
      layer: true
      x: 5, y:5
      width: w - 10
      height: w - 10
      click: (layer) ->
        console.log me.game
        me.game.undo()

    $(@controlPanel).drawRect
      fillStyle: "#0F0"
      fromCenter: false
      layer: true
      x: 5, y: 5 + w - 10 + 5
      width: w - 10
      height: w - 10
      click: (layer) ->
        console.log me.game
        me.game.redo()


  startGame: () ->
    me = this
    @resizeCanvas()
    @resizeControl()
    @resizeBG()

    $(window).resize ->
      me.resizeCanvas()
      me.resizeControl()
      me.resizeBG()

    @game.startGame()
