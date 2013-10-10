#= require lib/jquery-1.4
#= require rails
#= require lib/jquery-ui-effects-1.7.2.min
#= require lib/jquery.tipTip.minified
#= require layout_2008-07/swfobject
#= require layout_2008-07/json
#= require layout_2008-07/cookie
#= require layout_2008-07/rating
#= require layout_2008-07/application


localStorageSupport = ->
  try
    window.localStorage?
  catch error
    false


$ ->
  # legacy: rm old player cookies
  #
  Cookie.erase('player') if Cookie? and Cookie.exists('player')

  if localStorageSupport()
    # load player name and pass
    #
    name = localStorage['1337demos.player.name']
    pass = localStorage['1337demos.player.pass']

    $('[data-player=name]').val(name) if name
    $('[data-player=pass]').val(pass) if pass


    # update player name and pass when changed
    #
    $('[data-player=name]').blur (event) ->
      localStorage['1337demos.player.name'] = $(this).val()
    $('[data-player=pass]').blur (event) ->
      localStorage['1337demos.player.pass'] = $(this).val()

