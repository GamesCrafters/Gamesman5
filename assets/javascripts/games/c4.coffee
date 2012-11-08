window.game or= {}

window.game.title = "Connect 4"
window.game.asset = "c4"
window.game.parameters = {
  width: { type: "integer", values: [4,5,6,7], desc: "Number of Columns" }, 
  height: { type: "integer", values: [4,5,6], desc: "Number of Rows" },
}

window.game.getInitialBoard = (p) ->
  retval = ""
  for a in [1..p.width]
    for b in [1..p.height]
      retval += " "
  return retval

window.game.notifier = class extends GCAPI.GameNotifier
