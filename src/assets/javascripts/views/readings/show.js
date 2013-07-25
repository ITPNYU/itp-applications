views = window.views || {};

views.ReadingShowView = Backbone.View.extend({
  initalize: function () {
    this.render().el;
    this.model.bind('change', this.render, this);
  },

  template: JST['templates/readings/show'],

  events: {
    'click #response-publish' : 'addResponse'
  },

  render: function () {
    this.$el.html(this.template(this.model.toJSON()));
    var responsesUrl = '/api/assignments/' + this.model.get('id') + '/posts';
    var responses_view = new views.ResponsesView({collection: new collections.Posts});
    responses_view.setUrl(responsesUrl);
    this.$el.find('#reading-responses').html(responses_view.render().el);
    this.publishButton = Ladda.create(this.$el.find('#response-publish')[0]);
    return this;
  },

  addResponse: function () {
    var text = this.$el.find('#new-response textarea').val();
    this.publishButton.start();
    var title = "Response to " + this.model.get('title');
    var newPost = new models.Post({content: text, assignment_id: this.model.get('id'), title: title, draft: false});
    newPost.bind('change', this.render, this);
    newPost.save();

    return false;
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

views.NewResponseView = Backbone.View.extend({

});