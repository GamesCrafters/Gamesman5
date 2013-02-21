window.GCAPI or= {}

window.GCAPI.Ui = class
  constructor: (@game, @canvas, @controlPanel, @vvhPanel, @bg, @ratio) ->
    @_displayVVH = false

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

  resizeVVH: -> 
    h = window.innerHeight / 1.2
    w = h / 2
    left = (h / 5.7) - 1

    @vvhPanel.width = w
    @vvhPanel.height = h
    $(@vvhPanel).css('left', left)
    $(@vvhPanel).css('top', (window.innerHeight / 2) - (h / 2))

    $(@vvhPanel).drawRect
      layer: true
      fillStyle: "#000"
      fromCenter: false
      x: 0, y: 0
      width: w
      height: h

  resizeControl: ->
    me = this
    h = window.innerHeight / 1.2
    w = h / 5.7
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

    ypos = 5
    $(@controlPanel).drawImage
      source: "/images/undo@2x.png"
      fromCenter: false
      layer: true
      x: 5, y: ypos
      width: w - 10
      height: w - 10
      click: (layer) ->
        me.game.undo()

    ypos += (w - 10) + 5

    $(@controlPanel).drawImage
      source: "/images/redo@2x.png"
      fromCenter: false
      layer: true
      x: 5, y: ypos
      width: w - 10
      height: w - 10
      click: (layer) ->
        me.game.redo()

    ypos += (w - 10) + 5

    $(@controlPanel).drawImage
      source: "/images/vvh@2x.png"
      fromCenter: false
      layer: true
      x: 5, y: ypos
      width: w - 10
      height: w - 10
      click: (layer) ->
        $(me.vvhPanel).toggle()

    ypos += (w - 10) + 5

    $(@controlPanel).drawImage
      source: "/images/values@2x.png"
      fromCenter: false
      layer: true
      x: 5, y: ypos
      width: w - 10
      height: w - 10
      click: (layer) ->
        me.game.toggleValueMoves()

    ypos += (w - 10) + 5

    $(@controlPanel).drawImage
      source: "/images/settings@2x.png"
      fromCenter: false
      x: 5, y: ypos
      width: w - 10
      height: w - 10
      layer: true

    ypos += (w - 10) + 5

    $(@controlPanel).drawImage
      source: "/images/variants@2x.png"
      fromCenter: false
      layer: true
      x: 5, y: ypos
      width: w - 10
      height: w - 10

  startGame: () ->
    me = this
    @resizeCanvas()
    @resizeControl()
    @resizeVVH()
    @resizeBG()

    $(window).resize ->
      me.resizeCanvas()
      me.resizeControl()
      me.resizeVVH()
      me.resizeBG()

    @game.startGame()
