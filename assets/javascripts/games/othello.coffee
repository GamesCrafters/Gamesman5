# title: Othello
# asset: O
# Some kind of description

window.game or= {}

window.game.title = "Othello"
window.game.asset = "othello"
window.game.description = "Othello"
window.game.type = "c"
window.game.parameters = {
  width: { type: "integer", values: [4], desc: "Board Width" },
  height: { type: "integer", values: [4], desc: "Board Height" },
}

window.game.getInitialBoard = (p) ->
  retval = "     BW  WB     ;turn=1"
  #for a in [1..p.width]
   # for b in [1..p.height]
    #  retval += " "
  return retval

window.game.getDimensions = (p) ->
  return [p.width, p.height]

window.game.notifier = class extends GCAPI.GameNotifier
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
        char2 = board[22]
        name = String.fromCharCode(65 + column) + (row + 1)
        change = x_pixels * 0.1

        color = "0FF"
        if char == "B"
          color = "#000"
        else if char == "W"
          color = "#FFF"
        @canvas.drawRect
          fillStyle: "#00611C"
          strokeStyle: "#000"
          strokeWidth: 3
          x: xpos, y: ypos
          width: x_pixels
          height: y_pixels
          fromCenter: false
          layer: true
        if color == "#000"
           @canvas.drawArc
            fillStyle: color
            x: xpos + (x_pixels / 2), y: ypos + (y_pixels / 2)
            radius: (x_pixels / 2) - change
            layer: true
        else if color == "#FFF"
          @canvas.drawArc
            fillStyle: color
            x: xpos + (x_pixels / 2), y: ypos + (y_pixels / 2)
            radius: (x_pixels / 2) - change
            layer: true
        xpos += x_pixels
      ypos += y_pixels

  drawMoves: (data, game) ->
    x_pixels = Math.floor (game.notifier.canvas.width() / game.notifier.conf.width)
    y_pixels = Math.floor (game.notifier.canvas.height() / game.notifier.conf.height)
    window.moves = {}
    change = x_pixels * 0.1
    turnColor = 'rgba(0,0,0,0)'
    data = GCAPI.Game.sortMoves(data)
    size = 2
    val = ''

    for move in data
      window.moves[move.move] = move
      turn = move.board[22]
      if turn == '2'
        turnColor = 'rgba(0,0,0,.4)'
      else if turn == '1'
        turnColor = 'rgba(255,255,255,.4)'
      color = "#FFF"
      if game.showValueMoves
        color = game.getColor(move, data)
        console.log color
      column = row = 0
      size = 2
      if game.isC()
        pos = move.move
        val = pos.charAt(1)
        switch val
          when '1' then row = '3'
          when '2' then row = '2'
          when '3' then row = '1'
          when '4' then row = '0'
          #when 'P' then row = '0'
        val = pos.charAt(0) 
        switch val
          when 'a' then column = '0'
          when 'b' then column = '1'
          when 'c' then column = '2'
          when 'd' then column = '3'
          when 'P'
            column = '1.5'
            row = '1.5'
            size = 3
      else
        #column = move.move.charCodeAt(0) - 65
        #row = move.move[1] - 1
      xpos = x_pixels * column
      ypos = y_pixels * row

      pos = move.move
      val = pos.charAt[0]
      game.notifier.canvas.drawArc
        layer: true
        name: move.move
        fillStyle: turnColor
        x: xpos + (x_pixels / 2), y: ypos + (y_pixels / 2)
        radius: (x_pixels / size)  - change
        layer: true
        fromCenter: true
        click: (layer) ->
          game.makeMove window.moves[layer.name]

      if game.showValueMoves
        game.notifier.canvas.drawArc
          fillStyle: color
          x: xpos + (x_pixels / 2), y: ypos + (y_pixels / 2)
          radius: (x_pixels / 6)
          layer: true