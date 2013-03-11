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
      ival = parseInt(configurationHash[n])
      for value in i.values
        selected = if ival == value then "selected='selected'" else ""
        retval += "<option #{selected} value='" + value + "'>" + value + "</option>"
      retval += "</select>"
      retval += "</div>"
      return retval

    makeInput = () ->
      retval = ""
      return retval

    gameInfo = ""
    for own name,info of settings
      if typeof info is "object"
        switch info.type
          when "integer" then gameInfo += makeRange name,info

    contents = """
      <form action='play' class='custom'>
        <fieldset>
          <legend>Player Info</legend>
          <div class="row">
            <div class="three columns">
              <input type='text' name='player1' #{"value='#{configurationHash["player1"]}'" if configurationHash["player1"]} placeholder='Player 1 Name' />
            </div>
            <div class="three columns">
              <div class="row collapse">
                <div class="six columns">
                  <a class='#{"secondary" if configurationHash['p1-type'] == 'computer'} button expand prefix' id='p1-human'>Human</a>
                </div>
                <div class="six columns">
                  <a class='#{"secondary" if configurationHash['p1-type'] == 'human'} button expand prefix' id='p1-comp'>Computer</a>
                </div>
              </div>
            </div>
            <div class="three columns">
              <input type='text' name='player2' #{"value='#{configurationHash["player2"]}'" if configurationHash["player2"]} placeholder='Player 2 Name' />
            </div>
            <div class="three columns">
              <div class="row collapse">
                <div class="six columns">
                  <a class='#{"secondary" if configurationHash['p2-type'] == 'computer'} button expand prefix' id='p2-human'>Human</a>
                </div>
                <div class="six columns">
                  <a class='#{"secondary" if configurationHash['p2-type'] == 'human'} button expand prefix' id='p2-comp'>Computer</a>
                </div>
              </div>
            </div>
          </div>
        </fieldset>
        <fieldset>
          <legend>Game Info</legend>
          #{gameInfo}
        </fieldset>
        <input type="hidden" name="p1-type" id="p1-type" value="#{ if configurationHash['p1-type'] == "computer" then "computer" else "human"}" />
        <input type="hidden" name="p2-type" id="p2-type" value="#{ if configurationHash['p2-type'] == "computer" then "computer" else "human"}" />
        <input type="hidden" name="continue-game" id="continue-game" value="#{ if configurationHash['update-settings']? then "yes" else "no"}" />
        <input class="button" type="submit" value="#{ if configurationHash['update-settings']? then "Continue Game" else "Let's Play!"}" />
        #{ if configurationHash['update-settings'] then '<input class="button" type="submit" id="restartButton" value="New Game" />' else '' }
      </form>
    """
    c.html contents

    $('#p1-human').click (event) ->
      $('#p1-human').removeClass('secondary')
      $('#p1-comp').addClass('secondary')
      $('#p1-type').val('human')

    $('#p1-comp').click (event) ->
      $('#p1-human').addClass('secondary')
      $('#p1-comp').removeClass('secondary')
      $('#p1-type').val('computer')

    $('#p2-human').click (event) ->
      $('#p2-human').removeClass('secondary')
      $('#p2-comp').addClass('secondary')
      $('#p2-type').val('human')

    $('#p2-comp').click (event) ->
      $('#p2-human').addClass('secondary')
      $('#p2-comp').removeClass('secondary')
      $('#p2-type').val('computer')

    $('#restartButton').click (event) ->
      $('#continue-game').val('no')

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
