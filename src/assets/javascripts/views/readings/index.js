views = window.views || {};

views.ReadingIndexView = Backbone.View.extend({
  initialize: function () {
    this.render().el;
    this.collection.bind('set:current', this.render, this);
  },

  el: '#main-content',
  template: JST['templates/readings/index'],

  events: {
    'click .reading-list-item' : 'setReading'
  },

  render: function () {
    this.$el.html(this.template({readings: this.collection.toJSON()}));
    var currentReading = this.collection.getCurrent()
    if (currentReading !== null) {
      this.currentView = new views.ReadingShowView({model: currentReading});
      this.$el.find('#reading-detail').append(this.currentView.render().el);
    }
    return this;
  },

  setReading: function (e) {
    this.collection.setCurrent($(e.currentTarget).data().id);
  }
});