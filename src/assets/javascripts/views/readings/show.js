views = window.views || {};

views.ReadingShowView = Backbone.View.extend({
  initalize: function () {
    this.render().el;
  },

  template: JST['templates/readings/show'],

  render: function () {
    this.$el.html(this.template(this.model.toJSON()));
    return this;
  }
});