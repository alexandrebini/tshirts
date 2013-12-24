@TShirtApp.module 'HeaderApp.Show', (Show, App, Backbone, Marionette, $, _) ->

  class Show.Controller extends Marionette.Controller
    initialize: ->
      @headerRegion()

    headerRegion: ->
      headerView = @getHeaderView()
      App.headerRegion.show headerView

    getHeaderView: ->
      new Show.Header()