models = window.models || {};

models.Reading = Backbone.Model.extend({
  urlRoot: '/api/assignments',
  initialize: function () {
    this.unset('year');
  }
});