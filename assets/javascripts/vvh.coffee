window.drawVVH = (canvas, moveList) ->
	console.log moveList
	c = canvas  	# change to c = canvas

	maxH = c.height
	maxW = c.width
	xs = 10					# x-label interval
	ys = 20					# y-lable interval
	cmax = 30				# column spacing
	rmax = 20 				# row spacing
	moveNum = 0				# current turn number
	padx = 15
	pady = 5

	xlabel = ->				# labels moves until win
	  ctx = c.getContext("2d")
	  ctx.textBaseline = "middle"
	  ctx.textAlign = "center"
	  ctx.fillStyle = "white"	
	  ctx.fillText "D", canvas.width / 2, 5
	  i = 0
	  while i <= maxW/2
	    if i % (cmax) is 0
	   	  ctx.fillText i, maxW - i - padx, 20		# right player
	   	  ctx.fillText i, i + padx, 20				# left player
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
	      		ctx.fillText y, pady, 10 * (i + 3)
	      		ctx.fillText y, maxW - pady, 10 * (i + 3)
	    	i++
	ylabel()
	


	#practice =  ->
	#	ctx = c.getContext("2d")
	#	ctx.textBaseline = "middle"
	#	ctx.textAlign = "center"
	#	ctx.fillStle = "white"
#
#		moves = moveList

#		ctx.fillText moves, 50, 50
#	practice()







