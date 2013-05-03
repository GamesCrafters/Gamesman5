window.drawVVH = (canvas, moveList) ->

	#console.log moveList
	c = canvas

	#Game info
	turnNum = 0
	maxRemote = null

	#Move values
	lineColor = null
	tempBestMoveVal = null
	prevBestMoveVal = null

	#Temporary parsing variables
	tempMoveVal = null
	tempMoveX = null
	tempMoveY = null

	#Positions
	maxH = c.height
	maxW = c.width
	horCen = (maxW / 2)
	tempBestMoveX = null
	tempBestMoveY = null
	prevBestMoveX = null
	prevBestMoveY = null

	#Grid Spacing
	colSpace = null
	rowSpace = null				#determines the spacing of the x-labels on top of grid		
	padx = 15
	pady = 5
	disTop = 25

	#Labeling
	xLabelPad = disTop - 5
	yLabelPad = disTop + 3
	cenPad = 10

	#Dot Drawing
	dotDefault = disTop + 3
	turnPadding = 25
	dotSize = 6

	#Line Drawing
	linePadding = disTop + 2.5
	lineWidth = 2

	# Colors
	tieC = "rgb(255, 255, 0)"	# draw yellow
	winC = "rgb(0, 127, 0)"	# winning green
	loseC = "rgb(139, 0, 0)"	# losing red
	textcolor = "white"
	linecolor = "white"

	###
	Determines which turn it is
	###
	setTurnNum = ->

		turnNum = (moveList.length - 1)

	###
	Gets the color of the selected move to use in drawing the line between
	points on the VVH. Because the turns alternate, in order to draw the
	line with the correct color, it's necessary to invert the color.
	###
	setLineColor = (turn) ->

		tempMoveVal = moveList[turn].board.value

		if tempMoveVal == "lose"
			lineColor = "win"

		else if tempMoveVal == "win"
			lineColor = "lose"

		else
			lineColor = tempMoveVal

	###
	Sets the tempBestMove variable values to those associated
	with the best move of the turn passed in. Add one to the 
	remoteness value to account for difference in indexing.
	###
	setTempBestMove = (turn) ->

		loopTempX = null
		loopTempVal = null

		tempBestMoveY = (turn)

		i = 0

		###
		console.log turnNum
		console.log i
		console.log moveList
		###

		tempMoveVal = moveList[turn].moves[i].value
		tempMoveX = moveList[turn].moves[i].remoteness

		i += 1

		while i < (moveList[turn].moves.length)

			loopTempX = moveList[turn].moves[i].remoteness
			loopTempVal = moveList[turn].moves[i].value

			if tempMoveVal == "lose"

				if loopTempVal == "lose"
					if loopTempX > tempMoveX
						tempMoveX = loopTempX
				else if loopTempVal == "tie"
					tempMoveX = loopTempX
					tempMoveVal = loopTempVal
				else
					tempMoveX = loopTempX
					tempMoveVal = loopTempVal

			else if tempMoveVal == "tie"

				if loopTempVal == "win"
					tempMoveX = loopTempX
					tempMoveVal = loopTempVal

			else

				if loopTempVal == "win"
					if loopTempX < tempMoveX
						tempMoveX = loopTempX

			i += 1

		tempBestMoveX = tempMoveX + 1
		tempBestMoveVal = tempMoveVal
		
	###
	Determines the maximum number of moves until the endgame based on the initial
	moveList passed in. Add two to the largest value in the initial moveList so
	that there are (largest value in moveList) number of spots on each side of
	the grid's center line
	###
	maxVal = ->

		i = 0

		maxRemote = moveList[0].moves[i].remoteness

		i += 1

		while i < (moveList[0].moves.length)

			if moveList[0].moves[i].remoteness > maxRemote
				maxRemote = moveList[0].moves[i].remoteness

			i += 1

		maxRemote += 2

	###
	Draws the x-labels displaying how many moves until win for each
	player.
	###
	xlabel = ->
	  ctx = c.getContext("2d")
	  ctx.textBaseline = "middle"
	  ctx.textAlign = "center"
	  ctx.fillStyle = textcolor
	  label = maxRemote
	  i = horCen
	  j = horCen
	  ctx.fillText "D", horCen, 10
	  while label >= 0
	  	if label % rowSpace is 0
		   	ctx.fillText label, i, xLabelPad
		   	ctx.fillText label, j, xLabelPad
	    i += colSpace
	    j -= colSpace
	    label--

	###
	Draws the y-labels along the side of the grid, one
	value at a time.
	###
	ylabel = (turn) ->
	  ctx = c.getContext("2d")
	  ctx.textBaseline = "middle"
	  ctx.textAlign = "center"
	  ctx.fillStyle = textcolor
	  label = turn + 1

	  ctx.fillText label, pady, yLabelPad + (turn * turnPadding)
	  ctx.fillText label, maxW - pady, yLabelPad + (turn * turnPadding)

	###
	Draws the gridlines
	###
	grid = ->
		i = horCen 					# player 1 half of grid
		j = horCen 					# player 2 half of grid
		adjRemote = null			# the adjusted vale of Max Remote
		if maxRemote > 15
			adjRemote = maxRemote / 10
			colSpace = (horCen - padx)/adjRemote
		else
			adjRemote = maxRemote
		ctx = c.getContext("2d")
		ctx.strokeStyle = linecolor
		ctx.lineWidth = 1
		label = adjRemote
		while label >= 0
			ctx.moveTo i, disTop
			ctx.lineTo i, (maxH - pady)
			ctx.stroke()
			i += colSpace
			label -= 1
		label = adjRemote
		while label >= 0
			ctx.moveTo j, disTop
			ctx.lineTo j, (maxH - pady)
			ctx.stroke()
			j -= colSpace
			label -= 1

	###
	Draws the gridlines as well as the x-labels across the top.
	###
	drawGrid = ->


			# will calculate the max remoteness from the move list
			#maxRemote = 9
			colSpace = (horCen - padx)/maxRemote
			rowSpace = Math.floor(maxRemote/4)

			xlabel()

			grid()


	###
	Draws individual dots based on the remoteness, the move value,
	and the turn number.
	###
	drawDot = (remoteness, value, turn) ->
		color = null
		xpos = null
		ypos = dotDefault + (turnPadding * turn)
		turnRemote = remoteness
		radius = dotSize

		ctx = c.getContext("2d")
		if value is "win"
			color = winC
		else if value is "lose"
			color = loseC
		else
			color = tieC

		if value is "tie"

			xpos = horCen + ((maxRemote - turnRemote) * colSpace)

			ctx.beginPath()
			ctx.arc xpos, ypos, radius, 0, 2 * Math.PI, false
			ctx.fillStyle = color
			ctx.fill()
			ctx.lineWidth = 1
			ctx.strokeStyle = "black"
			ctx.stroke()

			xpos = horCen - ((maxRemote - turnRemote) * colSpace)

			ctx.beginPath()
			ctx.arc xpos, ypos, radius, 0, 2 * Math.PI, false
			ctx.fillStyle = color
			ctx.fill()
			ctx.lineWidth = 1
			ctx.strokeStyle = "black"
			ctx.stroke()

		else if turn % 2 is 0

			if value is "lose"
				xpos = horCen + ((maxRemote - turnRemote) * colSpace)

			else
				xpos = horCen - ((maxRemote - turnRemote) * colSpace)

			ctx.beginPath()
			ctx.arc xpos, ypos, radius, 0, 2 * Math.PI, false
			ctx.fillStyle = color
			ctx.fill()
			ctx.lineWidth = 1
			ctx.strokeStyle = "black"
			ctx.stroke()

		else

			if value is "lose"
				xpos = horCen - ((maxRemote - turnRemote) * colSpace)

			else
				xpos = horCen + ((maxRemote - turnRemote) * colSpace)

			ctx.beginPath()
			ctx.arc xpos, ypos, radius, 0, 2 * Math.PI, false
			ctx.fillStyle = color
			ctx.fill()
			ctx.lineWidth = 1
			ctx.strokeStyle = "black"
			ctx.stroke()

	###
	Handles drawing all of the dots necessary for the given turn.
	###
	drawDots = (turn) ->

		if turn isnt 0
			drawDot(prevBestMoveX, prevBestMoveVal, turn - 1)

		drawDot(tempBestMoveX, tempBestMoveVal, turn)
		ylabel(turn)

	###
	Slaps one line onto the grid.
	###
	sketchLine = (startX, endX, startY, endY, color) ->

		ctx = c.getContext("2d")
		ctx.strokeStyle = color
		ctx.lineWidth = lineWidth
		ctx.moveTo startX, startY
		ctx.lineTo endX, endY
		ctx.stroke()

	###
	Draws a colored line based using data from the previous move as well as
	the most recent move
	###
	drawLine = (lineVal, turn) ->
		
		xstart = null
		xend = null
		ystart = linePadding + (prevBestMoveY * turnPadding)
		yend = linePadding + (tempBestMoveY * turnPadding)

		firstPlayerStart = horCen + ((maxRemote - prevBestMoveX) * colSpace)
		secondPlayerStart = horCen - ((maxRemote - prevBestMoveX) * colSpace)
		firstPlayerEnd = horCen - ((maxRemote - tempBestMoveX) * colSpace)
		secondPlayerEnd = horCen + ((maxRemote - tempBestMoveX) * colSpace)

		color = null

		if lineVal is "win"
			color = winC
		else if lineVal is "lose"
			color = loseC
		else
			color = tieC

		if prevBestMoveVal is "tie"

			if tempBestMoveVal is "tie"
				xstart = firstPlayerStart
				xend = secondPlayerEnd

				sketchLine(xstart, xend, ystart, yend, color)

				xstart = secondPlayerStart
				xend = firstPlayerEnd

				sketchLine(xstart, xend, ystart, yend, color)

			else if turn % 2 is 0

				xstart = firstPlayerStart
				xend = firstPlayerEnd

				sketchLine(xstart, xend, ystart, yend, color)

				xstart = secondPlayerStart
				xend = firstPlayerEnd

				sketchLine(xstart, xend, ystart, yend, color)

			else

				xstart = firstPlayerStart
				xend = secondPlayerEnd

				sketchLine(xstart, xend, ystart, yend, color)

				xstart = secondPlayerStart
				xend = secondPlayerEnd

				sketchLine(xstart, xend, ystart, yend, color)

		else if tempBestMoveVal is "tie"

			if turn % 2 is 0
				xstart = firstPlayerStart
				xend = firstPlayerEnd

				sketchLine(xstart, xend, ystart, yend, color)

				xstart = firstPlayerStart
				xend = secondPlayerEnd

				sketchLine(xstart, xend, ystart, yend, color)

			else
				xstart = secondPlayerStart
				xend = secondPlayerEnd

				sketchLine(xstart, xend, ystart, yend, color)

				xstart = secondPlayerStart
				xend = firstPlayerEnd

				sketchLine(xstart, xend, ystart, yend, color)

		else if prevBestMoveVal is "win"

			if lineVal is "win" and turn % 2 is 0
				xstart = firstPlayerStart
				xend = secondPlayerEnd

			else if lineVal is "win" and turn % 2 is 1
				xstart = secondPlayerStart
				xend = firstPlayerEnd

			else if lineVal is "lose" and turn % 2 is 0
				xstart = firstPlayerStart
				xend = firstPlayerEnd

			else
				xstart = secondPlayerStart
				xend = secondPlayerEnd

			sketchLine(xstart, xend, ystart, yend, color)

		else if prevBestMoveVal is "lose"

			if lineVal is "lose" and turn % 2 is 0
				xstart = secondPlayerStart
				xend = firstPlayerEnd

			else if lineVal	is "lose" and turn % 2 is 1
				xstart = firstPlayerStart
				xend = secondPlayerEnd

			else if lineVal is "win" and turn % 2 is 0
				xstart = secondPlayerStart
				xend = secondPlayerEnd

			else
				xstart = firstPlayerStart
				xend = firstPlayerEnd

			sketchLine(xstart, xend, ystart, yend, color)

	###
	Updates the VVH after every turn.
	###
	draw = ->

		ctx = c.getContext("2d")
		ctx.fillStyle = "black"
		ctx.fillRect 0, 0, maxW, maxH

		setTurnNum()

		# This just ensures that none of this is accessed when the canvas is first created
		if moveList[turnNum].moves.length isnt 0

			#Draw the Grid
			maxVal()
			drawGrid()

			#Redraw the VVH on the grid
			i = 0

			while i < turnNum + 1

				setLineColor(i)
				setTempBestMove(i)

				if i isnt 0
					drawLine(lineColor, i)

				drawDots(i)

				prevBestMoveX = tempBestMoveX
				prevBestMoveY = tempBestMoveY
				prevBestMoveVal = tempBestMoveVal

				i += 1

	draw()
	draw()
