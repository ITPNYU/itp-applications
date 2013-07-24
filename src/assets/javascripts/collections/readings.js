collections = window.collections || {};

collections.Readings = Backbone.Collection.extend({
  model: models.Reading,

  setCurrent: function (id) {
    var collection = this;
    this.each(function(model) {
      console.log('current');
      if (model.get('id') === id) {
        collection.current = model;
        model.set('current', true);
      } else {
        model.unset('current');
      }
    });
    collection.trigger('set:current');
  },

  getCurrent: function () {
    return this.current || null;
  }
});