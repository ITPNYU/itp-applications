classes = {}
console.log 'oh shit'
classes.ExperiencesNewView = Backbone.View.extend
  initialize: ->
    @render().el
  render: ->
    $('#main-content').append("OH SHIT")
    @