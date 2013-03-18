# title: Connections
# asset: connections
# Connections is a basic game involving some things. these things are important
# and will play an important role in things.
window.game or= {}

window.game.title = "Connections"
window.game.asset = "connections"
window.game.description = "This is Connections"
window.game.parameters = {
  width: { type: "integer", values: [5,7], desc: "Board Width" },
  height: { type: "integer", values: [5,7], desc: "Board Height" },
  pieces: { type: "integer", values: [2,3], desc: "Number in a row" },
}

window.game.getInitialBoard = (p) ->
  retval = ""
  for a in [1..7]
      retval += " "
  return retval

window.game.getDimensions = (p) ->
  return [p.width, p.height]

window.game.notifier = class extends GCAPI.GameNotifier
  drawBoard: (board, game) ->
    me = this
    x_pixels = Math.floor (@canvas.width() / @conf.width)
    y_pixels = Math.floor (@canvas.height() / @conf.height)
    #console?.log x_pixels
    #console?.log y_pixels
    xpos = 0
    ypos = 0
    @canvas.drawRect
      layer: true
      fillStyle: "#E8E8E8"
      x: xpos, y: ypos
      width: @canvas.width()
      height: @canvas.height()
      fromCenter: false
    xpos += x_pixels
    for col in [0..@conf.width-2]
      @canvas.drawLine
        strokeStyle: "#000"
        strokeWidth: 1
        x1: xpos, y1: 0
        x2: xpos, y2: @canvas.height()
      xpos += x_pixels
    ypos +=	 y_pixels
    for row in [0..@conf.height-2]
      @canvas.drawLine
        strokeStyle: "#000"
        strokeWidth: 1
        x1: 0, y1: ypos
        x2: @canvas.width(), y2: ypos
      ypos += y_pixels
    drawSquares(@conf, @canvas)
    ypos = 0
    for row in [0..@conf.height-1]
      xpos = 0
      start = row*@conf.width
      for col in [0..@conf.width-1]
        index = start + col
        char = board[index]
        if char == "X"
          @canvas.drawLine
            layer: true
            name: String.fromCharCode(65 + col) + (row+1)
            strokeStyle: "#F00"
            strokeWidth: 3
            x1: xpos, y1: ypos
            x2: xpos + x_pixels, y2: ypos + y_pixels
            click: (layer) ->
              game.makeMove
              window.moves[layer.name]
        xpos += x_pixels
      ypos += y_pixels		
	
	
  drawSquares = (conf, canvas) ->
    for a in [1..conf.width] by 2
      for b in [0..conf.height] by 2
        drawOneSquare(conf, canvas, a, b, 0.6, "blue")
    for a in [0..conf.width] by 2
      for b in [1..conf.height] by 2
        drawOneSquare(conf, canvas, a, b, 0.6, "red")


  drawOneSquare = (conf, canvas, xp, yp, scale, color) ->
    offset = (1-scale)/2
    x_pixels = Math.floor (canvas.width() / conf.width)
    y_pixels = Math.floor (canvas.height() / conf.height)
    squareOffset = offset * x_pixels
    canvas.drawRect
      fillStyle: color
      x: xp*x_pixels+squareOffset
      y: yp*y_pixels+squareOffset
      width: x_pixels - 2*squareOffset
      height: y_pixels - 2*squareOffset
      fromCenter: false
	  
  drawMoves: (data, game) ->
    window.moves = {}
    for move in data
      window.moves[move.move] = move
