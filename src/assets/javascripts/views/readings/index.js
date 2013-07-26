views = window.views || {};

views.ReadingIndexView = Backbone.View.extend({
  initialize: function (opts) {
    console.log(opts);
    this.render().el;
    this.collection.bind('set:current', this.render, this);
    if (opts.current) {
      this.collection.setCurrent(opts.current);
    }
  },

  el: '#main-content',
  template: JST['templates/readings/index'],

  events: {
    'click .reading-list-item' : 'setReading'
  },

  render: function () {
    var currentReading = this.collection.getCurrent();
    this.$el.html(this.template({readings: this.collection.toJSON()}));
    this.currentView = new views.ReadingShowView({model: currentReading});
    this.$el.find('#expanded-reading').append(this.currentView.render().el);
    return this;
  },

  setReading: function (e) {
    this.collection.setCurrent($(e.currentTarget).data().id);
  }
});