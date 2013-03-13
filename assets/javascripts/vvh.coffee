window.drawVVH = (canvas, moveList) ->
	console.log moveList
	c = document.getElementById(canvas)

	maxH = c.height
	maxW = c.width
	xs = 20					# x-label interval
	ys = 20					# y-lable interval
	rmax = 20				# row spacing

	ctx = c.getContext("2d")
	ctx.fillStyle = "black"
	ctx.fillRect 0, 0, maxW, maxH

	xlabel = ->				# labels the turn number
	  ctx = c.getContext("2d")
	  ctx.textBaseline = "middle"
	  ctx.textAlign = "center"
	  ctx.fillStyle = "white"	
	  ctx.fillText "D", canvas.width / 2, 10 * 2
	  i = 0
	  while i <= maxW
	    if i % (rmax) is 0
	   	  ctx.fillText i, (maxW/2) - i , 20
	   	  ctx.fillText i, (maxW/2) + i, 20
	    i += xs
	xlabel()


