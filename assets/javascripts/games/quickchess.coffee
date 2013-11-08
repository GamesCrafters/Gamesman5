# title: Quickchess
# asset: ttt
# Quickchess is a strange variant of chess.
window.game or= {}

window.game.title = "Quickchess"
window.game.asset = "quickchess"
window.game.description = "This is QuickChess"
window.game.type = "c"
window.game.parameters = {
  width: { type: "integer", values: [3], desc: "Board Width" },
  height: { type: "integer", values: [4], desc: "Board Height" },
}

window.game.getDimensions = (p) ->
  return [p.width, p.height]

window.game.notifier = class extends GCAPI.GameNotifier
  pieceImgSources:
    'k': 'Chess_kdt45.svg'
    'K': 'Chess_klt45.svg'
    'q': 'Chess_qdt45.svg'
    'Q': 'Chess_qlt45.svg'
    'r': 'Chess_rdt45.svg'
    'R': 'Chess_rlt45.svg'
  drawBoard: (board, game) ->
    me = this
    x_pixels = Math.floor (@canvas.width() / @conf.width)
    y_pixels = Math.floor (@canvas.height() / @conf.height)
    xpos = 0
    ypos = 0
    for row in [0..@conf.height-1]
      xpos = 0
      start = row*@conf.width
      for column in [0..@conf.width-1]
        index = start + column
        char = board[index]

        change = x_pixels * 0.1

        @canvas.drawRect
          fillStyle: "#7F7F7F"
          strokeStyle: "#000"
          strokeWidth: 3
          x: xpos, y: ypos
          width: x_pixels
          height: y_pixels
          fromCenter: false
          layer: true
        piece_image = @pieceImgSources[char]
        if piece_image
          src = '/images/chess_pieces/' + piece_image
          @canvas.drawImage
            source: src
            x: xpos + change
            y: ypos + change
            width: x_pixels - (change * 2)
            height: y_pixels - (change * 2)
            fromCenter: false
            layer: true

        xpos += x_pixels
      ypos += y_pixels

  drawMoves: (data, game) ->
    x_pixels = Math.floor (game.notifier.canvas.width() / game.notifier.conf.width)
    y_pixels = Math.floor (game.notifier.canvas.height() / game.notifier.conf.height)

    window.moves = {}

    data = GCAPI.Game.sortMoves(data)

    columnMap =
      'a': 1
      'b': 2
      'c': 3

    rotateMap =
      '1,1' : -45 - 180
      '2,2' : -45 - 180
      '3,3' : -45 - 180
      '4,4' : -45 - 180
      '-1,-1' : 45 - 90
      '-2,-2' : 45 - 90
      '-3,-3' : 45 - 90
      '-4,-4' : 45 - 90
      '-1,1' : -45 - 90
      '-2,2' : -45 - 90
      '-3,3' : -45 - 90
      '-4,4' : -45 - 90
      '1,-1' : 45
      '2,-2' : 45
      '3,-3' : 45
      '4,-4' : 45
      '1,0' : 90
      '2,0' : 90
      '3,0' : 90
      '4,0' : 90
      '-1,0' : -90
      '-2,0' : -90
      '-3,0' : -90
      '-4,0' : -90
      '0,1' : -180
      '0,2' : -180
      '0,3' : -180
      '0,4' : -180
      '0,-1' : 0
      '0,-2' : 0
      '0,-3' : 0
      '0,-4' : 0

    for move in data
      window.moves[move.move] = move
      color = "#FFF"
      if game.showValueMoves or true
        color = game.getColor(move, data)
      start_column = columnMap[move.move[0]] - 1
      start_row = @conf.height - parseInt(move.move[1])
      end_column = columnMap[move.move[2]] - 1
      end_row = @conf.height - parseInt(move.move[3])
      x_start = x_pixels * (start_column + 0.5)
      y_start = y_pixels * (start_row + 0.5)
      x_end = x_pixels * (end_column + 0.5)
      y_end = y_pixels * (end_row + 0.5)
      triangle_radius = x_pixels / 16
      x_diff = end_column - start_column
      y_diff = end_row - start_row
      angle = rotateMap[x_diff + "," + y_diff]
      console.log "Diff = (" + x_diff + ", " + y_diff + ")"
      console.log "Angle = " + angle
      x_len = x_diff * x_pixels
      y_len = y_diff * y_pixels
      theta = (angle - 90) * Math.PI / 180
      magic = 0.7 # Used to add spacing, etc.
      len = Math.sqrt(x_pixels * x_pixels + y_pixels * y_pixels) * magic
      x = x_end + Math.sin(theta) * x_pixels
      y = y_end + Math.cos(theta) * y_pixels
      if x_diff == 0
        y = y_end - y_pixels * Math.sign(y_diff) * magic
        x = x_end
      if y_diff == 0
        y = y_end
        x = x_end - x_pixels * Math.sign(x_diff) * magic
      else if x_diff > 0 and y_diff > 0
        x = x_end - x_pixels * Math.sign(x_diff) * magic
        y = y_end - y_pixels * Math.sign(y_diff) * magic
      else
        x = x_end - x_pixels * Math.sign(x_diff) * magic
        y = y_end - y_pixels * Math.sign(y_diff) * magic
      @canvas.drawLine
        strokeStyle: color
        fillStyle: color
        layer: true
        name: move.move
        click: (layer) ->
          game.makeMove window.moves[layer.name]
        x1: x, y1: y,
        x2: x + len/6 * Math.sin(theta), y2: y - len/6 * Math.cos(theta),
        x3: x + 2/3*len * Math.cos(theta) + len/6 * Math.sin(theta), y3: y - len/6 * Math.cos(theta) + 2/3 * len * Math.sin(theta),
        x4: x + 2/3*len*Math.cos(theta) + len/3*Math.sin(theta), y4: y - len/3*Math.cos(theta) + 2/3*len*Math.sin(theta),
        x5: x + len*Math.cos(theta) + len/12*Math.sin(theta), y5: y - len/12*Math.cos(theta) + len*Math.sin(theta), 
        x6: x + 2/3*len*Math.cos(theta) - len/6*Math.sin(theta), y6: y + len/6*Math.cos(theta) + 2/3*len*Math.sin(theta),
        x7: x + 2/3*len*Math.cos(theta), y7: y + 2/3*len*Math.sin(theta),
        x8: x, y8: y
