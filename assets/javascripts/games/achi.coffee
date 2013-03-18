# title: Achi
# asset: achi
# Achi is a basic game involving some things. these things are important
# and will play an important role in things.
window.game or= {}

window.game.title = "Achi"
window.game.asset = "achi"
window.game.description = "This is Achi"
window.game.type = "c"
window.game.parameters = {
  width: { type: "integer", values: [3,4,5], desc: "Board Width" },
  height: { type: "integer", values: [3,4,5], desc: "Board Height" },
  pieces: { type: "integer", values: [3,4,5], desc: "Number in a row" },
}

window.game.getInitialBoard = (p) ->
  retval = ""
  for a in [1..p.width]
    for b in [1..p.height]
      retval += " "
  return retval
  
window.game.getDimensions = (p) ->
  return [p.width, p.height]

window.game.notifier = class extends GCAPI.GameNotifier
  drawBoard: (board, game) ->
    me = this
    x_pixels = Math.floor (@canvas.width() / @conf.width)
    y_pixels = Math.floor (@canvas.height() / @conf.height)
    x_offset = .1 * x_pixels
    y_offset = .1 * y_pixels
    xpos = x_offset
    ypos = y_offset
    
    for column in [0..@conf.width-1]
      xpos = @canvas.width()/(@conf.width-1)*column
      if column == 0
        xpos += x_offset
      else if column == @conf.width-1
        xpos -= x_offset
      @canvas.drawLine
        strokeStyle: "#000",
        strokeWidth: 3,
        x1: xpos, y1: y_offset,
        x2: xpos, y2: y_pixels*@conf.height-y_offset,
        layer: true
    
    for row in [0..@conf.height-1]
      ypos = @canvas.height()/(@conf.height-1)*row
      if row == 0 
        ypos += y_offset
      else if row == @conf.height-1
        ypos -= y_offset
      @canvas.drawLine
        strokeStyle: "#000",
        strokeWidth: 3,
        x1: x_offset, y1: ypos,
        x2: x_pixels*@conf.width-x_offset, y2: ypos,
        layer: true
     
    @canvas.drawLine
      strokeStyle: "#000",
      strokeWidth: 3,
      x1: x_offset, y1: y_offset,
      x2: x_pixels*@conf.width-x_offset, y2: y_pixels*@conf.height-y_offset
      layer: true
    @canvas.drawLine
      strokeStyle: "#000",
      strokeWidth: 3,
      x1: x_pixels*@conf.width-x_offset, y1: y_offset,
      x2: x_offset, y2:y_pixels*@conf.height-y_offset
      layer:true
    
    for row in [0..@conf.height-1]
      ypos = @canvas.height()/(@conf.height-1)*row
      if row == 0 
        ypos += y_offset
      else if row == @conf.height-1
        ypos -= y_offset
      for column in [0..@conf.width-1]
        xpos = @canvas.width()/(@conf.width-1)*column
        if column == 0
          xpos += x_offset
        else if column == @conf.width-1
          xpos -= x_offset
        console.log xpos
        @canvas.drawArc
          fillStyle: "#000",
          x: xpos, y: ypos,
          radius: 10,
          start: 0, end: 360

        

  drawMoves: (data, game) ->
    x_pixels = Math.floor (game.notifier.canvas.width() / game.notifier.conf.width)
    y_pixels = Math.floor (game.notifier.canvas.height() / game.notifier.conf.height)

    window.moves = {}

    data = GCAPI.Game.sortMoves(data)

    for move in data
      window.moves[move.move] = move
      color = "#FFF"

      if game.showValueMoves
        color = game.getColor(move, data)
        console.log color

      column = row = 0
      if game.isC()
        val = parseInt(move.move) - 1
        column = val % 3
        row = Math.floor(val / 3)
      else
        column = move.move.charCodeAt(0) - 65
        row = move.move[1] - 1

      xpos = x_pixels * column
      ypos = y_pixels * row

      game.notifier.canvas.drawRect
        layer: true
        name: move.move
        fillStyle: "#7F7F7F"
        strokeStyle: "#000"
        strokeWidth: 3
        x: xpos, y: ypos
        width: x_pixels
        height: y_pixels
        fromCenter: false
        click: (layer) ->
          game.makeMove window.moves[layer.name]

      if game.showValueMoves
        game.notifier.canvas.drawArc
          fillStyle: color
          x: xpos + (x_pixels / 2), y: ypos + (y_pixels / 2)
          radius: (x_pixels / 5)
          layer: true
