classes.ExperiencesNewView = Backbone.View.extend
  initialize: ->
    @render().el
  template: JST['templates/experiences/new']
  render: ->
    $('#main-content').append(@template)
    @