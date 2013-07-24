collections = window.collections || {};

collections.Posts = Backbone.Collection.extend({
  model: models.Post
});