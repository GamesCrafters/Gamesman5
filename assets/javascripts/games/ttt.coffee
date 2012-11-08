# title: Tic Tac Toe
# asset: ttt
# Tic Tac Toe is a basic game involving some things. these things are important
# and will play an important role in things.
window.game or= {}

window.game.title = "Tic Tac Toe"
window.game.asset = "ttt"
window.game.description = "This is Tic Tac Toe"
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

window.game.notifier = class extends GCAPI.GameNotifier
  drawBoard: (board, game) ->
    me = this
    x_pixels = Math.floor (@canvas.width() / @conf.width)
    y_pixels = Math.floor (@canvas.height() / @conf.height)
    console?.log x_pixels
    console?.log y_pixels
    xpos = 0
    ypos = 0
    for row in [0..@conf.height-1]
      xpos = 0
      start = row*@conf.height
      for column in [0..@conf.width-1]
        index = start + column
        char = board[index]
        color = "#FFF"
        if char == "X"
          color = "#F00"
        else if char == "O"
          color = "#00F"
        @canvas.drawRect
          layer: true
          name: String.fromCharCode(65 + column) + (row+1)
          fillStyle: color
          strokeStyle: "#000"
          strokeWidth: 3
          x: xpos, y: ypos
          width: x_pixels
          height: y_pixels
          fromCenter: false
          click: (layer) ->
            game.makeMove window.moves[layer.name]
        xpos += x_pixels
      ypos += y_pixels

  drawMoves: (data, game) ->
    window.moves = {}
    for move in data
      window.moves[move.move] = move
