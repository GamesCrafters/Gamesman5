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
  pieceMap:
    'K': 'Chess_kdt45.svg'
    'k': 'Chess_klt45.svg'
    'Q': 'Chess_qdt45.svg'
    'q': 'Chess_qlt45.svg'
    'R': 'Chess_rdt45.svg'
    'r': 'Chess_rlt45.svg'
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

        #color = "#FFF"
        #if char in ['Q', 'K', 'R']
          #color = "#F00"
        #else if char in ['q', 'k', 'r']
          #color = "#00F"
        @canvas.drawRect
          fillStyle: "#7F7F7F"
          strokeStyle: "#000"
          strokeWidth: 3
          x: xpos, y: ypos
          width: x_pixels
          height: y_pixels
          fromCenter: false
          layer: true
        #console.log 'Canvas:', @canvas
        img = new Image()
        func = ((xpos, ypos) -> () ->
          console.log 'Drawing image at', xpos, ypos
          #console.log me.canvas.drawImage
          #me.canvas.drawImage
          #me.canvas.drawRect
            #fillStyle: color
            #strokeStyle: "#000"
            #strokeWidth: 3
            #x: xpos + change, y: ypos + change
            #width: x_pixels - (change * 2)
            #height: y_pixels - (change * 2)
            #fromCenter: false
            #layer: true
          #console.log me.canvas.drawImage
          document.getElementById('GCAPI-main').getContext('2d').drawImage(img, xpos + change, ypos + change, x_pixels - (change * 2), y_pixels - (change * 2))
          #me.canvas.drawImage img, xpos + change, ypos + change
          #console.log 'Output =', out
          #me.canvas.drawRect
            #img: img,
            #x: xpos + change, y: ypos + change
            #width: x_pixels - (change * 2)
            #height: y_pixels - (change * 2)
            #fromCenter: false
            #layer: true
          )(xpos, ypos)
        img.onload = func
          #me.canvas.getContext('2d').drawImage(img, xpos, ypos, x_pixels - (change * 2), y_pixels - (change * 2))
        #img.src = '/images/Chess_symbols.PNG'
        src = '/images/chess_pieces/' + @pieceMap[char]
        console.log 'Drawing image' + src
        img.src = '/images/chess_pieces/' + @pieceMap[char]
        #console.log @canvas.drawRect
        #if false && color == "#F00"
          #@canvas.drawRect
            #fillStyle: color
            #strokeStyle: "#000"
            #strokeWidth: 3
            #x: xpos + change, y: ypos + change
            #width: x_pixels - (change * 2)
            #height: y_pixels - (change * 2)
            #fromCenter: false
            #layer: true
        #else if false && color == "#00F"
          #@canvas.drawArc
            #fillStyle: color
            #strokeStyle: "#000"
            #strokeWidth: 3
            #x: xpos + (x_pixels / 2), y: ypos + (y_pixels / 2)
            #radius: (x_pixels / 2) - change
            #layer: true

        xpos += x_pixels
      ypos += y_pixels

  drawMoves: (data, game) ->
    x_pixels = Math.floor (game.notifier.canvas.width() / game.notifier.conf.width)
    y_pixels = Math.floor (game.notifier.canvas.height() / game.notifier.conf.height)

    window.moves = {}

    data = GCAPI.Game.sortMoves(data)
    #console.log 'moves', data

    for move in data
      window.moves[move.move] = move
      color = "#FFF"

      if game.showValueMoves
        color = game.getColor(move, data)
        #console.log color

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
