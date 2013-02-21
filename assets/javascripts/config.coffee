# Configure a new game. read a parameters file in this format (like for
# TicTacToe)

# {
#  width: "3-4",
#  height: "3-4",
#  pieces: "3-4"
# }

$ = jQuery

$.fn.extend
  getConfigure: (options) ->
    settings =
      debug: false

    settings = $.extend settings, options

    log = (msg) ->
      console?.log msg if settings.debug

    c = @first()

    contents = ""
    makeRange = (n,i) ->
      v = i.values
      description = i.desc
      retval = ''
      retval += '<div class="three columns end">'
      retval += description
      retval += "<select id='custom" + n + "' name='" + n + "' >"
      for value in i.values
        retval += "<option value='" + value + "'>" + value + "</option>"
      retval += "</select>"
      retval += "</div>"
      return retval

    makeInput = () ->
      retval = ""
      return retval

    contents = "<form action='play' class='custom'>"
    contents += '<fieldset>'
    contents += '<legend>Player Info</legend>'
    contents += '<div class="row">'
    contents += "<div class='six columns'>"
    contents += "<input type='text' name='player1' placeholder='Player 1 Name' /></div>"
    contents += "<div class='six columns'>"
    contents += "<input type='text' name='player2' placeholder='Player 2 Name' /></div>"
    contents += '</fieldset></div>'
    contents += '<fieldset>'
    contents += '<legend>Game Info</legend>'
    for own name,info of settings
      if typeof info is "object"
        switch info.type
          when "integer" then contents += makeRange name,info
    contents += "</fieldset>"
    contents += '<input class="button" type="submit" value="Let\'s Play!" />'
    contents += "</form>"

    c.html contents
    return @


window.ensureConfigParameters = () ->
  problems = []
  if ! window.game?
    problems.push "You Must Create a window.game object in your game file"
  else
    if !window.game.title?
      problems.push "You must define a window.game.title string with the title of the game"
    if !window.game.asset?
      problems.push "You must define a window.game.asset string with the asset name. This should be the same as the name of the js file, and any image assets"
    if !window.game.parameters?
      problems.push "You must define a parameters object. Please refer to ttt.js.coffee for an example of this"
  if problems.length > 0
    alert problems.join("\n\n")
    return false
  return true
