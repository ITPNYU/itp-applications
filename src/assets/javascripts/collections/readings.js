collections = window.collections || {};

collections.Readings = Backbone.Collection.extend({
  model: models.Reading
});