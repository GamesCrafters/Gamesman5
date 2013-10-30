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
      '-1,-1' : 45
      '-2,-2' : 45
      '-3,-3' : 45
      '-4,-4' : 45
      '-1,1' : 45
      '-2,2' : 45
      '-3,3' : 45
      '-4,4' : 45
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
      @canvas.drawLine
        strokeStyle: color
        strokeWidth: 10
        x1: x_start
        y1: y_start
        x2: x_end
        y2: y_end
        layer: true
        name: move.move
        click: (layer) ->
          game.makeMove window.moves[layer.name]
      x_diff = end_column - start_column
      y_diff = end_row - start_row
      angle = rotateMap[x_diff + "," + y_diff]
      console.log "Diff = (" + x_diff + ", " + y_diff + ")"
      console.log "Angle = " + angle
      @canvas.drawPolygon
        strokeStyle: color
        strokeWidth: 10
        x: x_end
        y: y_end
        radius: x_pixels / 16
        sides: 3
        rotate: angle
        layer: true
        name: move.move
        click: (layer) ->
          game.makeMove window.moves[layer.name]
