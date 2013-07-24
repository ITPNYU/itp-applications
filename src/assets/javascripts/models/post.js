models = window.models || {};

models.Post = Backbone.Model.extend({
  urlRoot: '/api/posts'
});