@TShirtApp = do (Backbone, Marionette) ->

  App = new Marionette.Application

  App.addRegions
    headerRegion: '#header-region'

  App.addInitializer ->
    App.module('HeaderApp').start()

  App.on 'initialize:after', ->
    if Backbone.history
      Backbone.history.start()

  App