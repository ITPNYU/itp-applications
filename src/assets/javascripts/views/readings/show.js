views = window.views || {};

views.ReadingShowView = Backbone.View.extend({
  initalize: function () {
    this.render().el;
    this.model.bind('change', this.render, this);
  },

  stuff: function () {console.log(this.model)},

  template: JST['templates/readings/show'],

  render: function () {
    this.$el.html(this.template(this.model.toJSON()));
    var responsesUrl = '/api/assignments/' + this.model.get('id') + '/posts';
    var responses_view = new views.ResponsesView({collection: new collections.Posts});
    responses_view.setUrl(responsesUrl);
    this.$el.find('#reading-responses').html(responses_view.render().el);
    return this;
  }
});

views.ResponsesView = Backbone.View.extend({
  initialize: function (opts,a) {
    this.collection.bind('reset', this.render, this);
    this.collection.bind('change', this.render, this);
  },

  setUrl: function (url) {
    this.collection.url = url;
    this.collection.fetch();
  },

  template: JST['templates/readings/responses'],

  render: function () {
    console.log('render resposnes', this.collection.toJSON(),this.$el);
    this.$el.html(this.template({responses: this.collection.toJSON()}));
    return this;
  }
});