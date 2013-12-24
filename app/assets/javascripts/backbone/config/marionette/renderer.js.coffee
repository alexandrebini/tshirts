do (Marionette) ->
  _.extend Marionette.Renderer,

  lookups: ['apps', 'components']

  render: (template, data) ->
    return unless template
    path = @getTemplate(template)
    throw "Template #{ template } not found!" unless path
    path(data)

  getTemplate: (template) ->
    for lookup in @lookups
      path = "#{ lookup }/#{ template }"
      return JST[path] if JST[path]