window.drawVVH = (canvas, moveList) ->


	#console.log moveList
	console.log moveList[0].moves[0]
	c = canvas  	# change to c = canvas

	# Positions
	maxH = c.height
	maxW = c.width
	horCen = maxW / 2
	xs = 10					# x-label interval
	ys = 20					# y-lable interval
	cmax = 30				# column spacing
	rmax = 20 				# row spacing
	moveNum = 0				# current turn number
	padx = 18
	pady = 5
	disTop = 23
	xLabelPad = 12.5
	cenPad = 10
	lastDotX = 0	# x position of the last Dot
	lastDotY = 0	# y position of the last Dot

	# Dot Colors

	tieC = "rgb(255, 255, 255)"	# draw yellow
	winC = "rgb(0, 127, 0)"	# winning green
	loseC = "rgb(139, 0, 0)"	# losing red
	

	xlabel = ->				# labels moves until win
	  ctx = c.getContext("2d")
	  ctx.textBaseline = "middle"
	  ctx.textAlign = "center"
	  ctx.fillStyle = "white"
	  ctx.fillText "D", horCen, disTop - xLabelPad
	  i = 0
	  while i <= maxW/2
	    if i % (cmax) is 0

		#if i <= (disTop - xLabelPad) and i >= (disTop - xLabelPad)
	   	  ctx.fillText i, maxW - i - padx - 3, disTop		# right player
	   	  ctx.fillText i, i + padx, disTop				# left player
	    i++
	xlabel()


	ylabel = ->				# labels move turns
		ctx = c.getContext("2d")
		ctx.textBaseline = "middle"
		ctx.textAlign = "center"
		ctx.fillStyle = "white"
		i = 0
		y = 0
		while i < (maxH * 3)
	    	if i % ys is 0
	      		y = i
	      		#ctx.fillText y, pady + 3, 10 * (i + 3)
	      		ctx.fillText y, maxW - pady - 3, 10 * (i + 3)
	    	i++
	ylabel()
	


	#practice =  ->
	#	ctx = c.getContext("2d")
	#	ctx.textBaseline = "middle"
	#	ctx.textAlign = "center"
	#	ctx.fillStle = "white"

	#	moves = null
	#	if moveList != null
	#		moves = moveList

	#	ctx.fillText moves, 50, 50
	#practice()

	# Draw the Grid
	grid = ->
		i = padx
		ctx = c.getContext("2d")
		ctx.strokeStyle = "white"
		ctx.lineWidth = 1
		while i < maxW - padx

			if i >= horCen - .5 and i <= horCen + .5 
				ctx.beginPath()
				ctx.moveTo i, disTop - 2
				ctx.lineTo i, maxH - 5
				ctx.stroke()
			else
				#ctx.fillText i, i, disTop + i * 2
				ctx.beginPath()
				ctx.moveTo i, disTop + 5
				ctx.lineTo i, maxH - 5
				ctx.stroke()
			i += 10
	grid()


	# create a circle with the given move color 'c'

	# the current canvas 'canvas'
	# xpos = x position
	# ypos = y position
	# c = color (win==green, draw==yellow, lose==red)
	drawDot = (canvas, xpos, ypos, c) ->
		ctx = canvas.getContext("2d")
		radius = 4
		ctx.beginPath()
		ctx.arc xpos, ypos, radius, 0, 2 * Math.PI, false
		ctx.fillStyle = c
		ctx.fill()
		ctx.lineWidth = 1
		ctx.strokeStyle = "black"
		ctx.stroke()


	# plot circle onto canvas based on data
	plotValues = ->
		i = padx
		while i < maxW
			drawDot(c, i, i, loseC)
			i+= 30
	plotValues()

