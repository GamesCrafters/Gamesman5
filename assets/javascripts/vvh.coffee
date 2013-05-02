window.drawVVH = (canvas, moveList) ->

	console.log moveList
	c = canvas

	#Game info
	turnNum = 0
	maxRemote = null

	#Move values
	tempSelectedMoveVal = null
	tempBestMoveVal = null

	#Temporary variables
	tempMoveVal = null
	tempMoveX = null
	tempMoveY = null

	#Positions
	maxH = c.height
	maxW = c.width
	horCen = (maxW / 2)
	tempBestMoveX = null					
	tempBestMoveY = null					

	#Grid Spacing
	colSpace = null				
	rowSpace = null				
	padx = 15
	pady = 5
	disTop = 23

	#Labeling
	xLabelPad = 12.5
	yLabelPad = 0
	cenPad = 10

	# Colors
	tieC = "rgb(255, 255, 255)"	# draw yellow
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
	setTempSelectedMove = (turn) ->

		tempMoveVal = moveList[turn].board.value

		if tempMoveVal == "lose"
			tempSelectedMoveVal = "win"

		else if tempMoveVal == "win"
			tempSelectedMoveVal = "lose"

		else
			tempSelectedMoveVal = tempMoveVal

	###
	Sets the tempBestMove variable values to those associated
	with the best move of the turn passed in.
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

		i += 1;

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

		tempBestMoveX = tempMoveX
		tempBestMoveVal = tempMoveVal
		
	###
	Determines the maximum number of moves until the endgame based on the initial
	moveList passed in. Add one to the largest value in the initial moveList so
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

		maxRemote +=1

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
		   	ctx.fillText label, i, 20
		   	ctx.fillText label, j, 20
	    i += colSpace
	    j -= colSpace
	    label--

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
			ctx.moveTo i, 25
			ctx.lineTo i, (maxH - pady)
			ctx.stroke()
			i += colSpace
			label -= 1
		label = adjRemote
		while label >= 0
			ctx.moveTo j, 25
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
	Updates the VVH after every turn.
	###
	draw = ->

		setTurnNum();

		# This just ensures that none of this is accessed when the canvas is first created
		if moveList[turnNum].moves.length isnt 0

			console.log "turnNum: " + turnNum

			#Draw the Grid
			maxVal()
			drawGrid()

			i = 0

			while i < turnNum + 1

				setTempSelectedMove(i)			
				setTempBestMove(i)

				#drawLine()

				#drawDot()

				console.log "tempSelectedMoveVal " + i + ": " + tempSelectedMoveVal
				console.log "tempBestMoveVal " + i + ": " + tempBestMoveVal
				console.log "tempBestMoveX " + i + ": " + tempBestMoveX
				console.log "tempBestMoveY " + i + ": " + tempBestMoveY

				i += 1

	draw()

