collections = window.collections || {};

collections.Readings = Backbone.Collection.extend({
  model: models.Reading,

  comparator: function (model) {
    return model.get('title').toLowerCase();
  },

  setCurrent: function (id) {
    var collection = this;

    this.each(function(model) {
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
    this.current = this.current || false;

    if (this.current === false) {
      this.current = this.models[0];
      this.models[0].set('current', true);
    }

    return this.current;
  }
});