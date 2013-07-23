views = window.views || {};

views.ReadingIndexView = Backbone.View.extend({
  initialize: function () {
    this.render().el;
  },

  el: '#main-content',
  template: JST['templates/readings/index'],

  render: function () {
    this.$el.html(this.template({readings: this.collection.toJSON()}));
    return this;
  }
});