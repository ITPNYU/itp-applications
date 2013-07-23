views = window.views || {};

views.ReadingEditView = Backbone.View.extend({
  initialize: function () {
    this.render().el;
  },

  el: '#main-content',

  template: JST["templates/readings/edit"],

  events: {
    'click #reading-form-draft' : 'saveAsDraft',
    'click #reading-form-publish' : 'saveAsPublished',
  },

  render: function () {
    this.$el.html(this.template(this.model.toJSON()));

    this.$el.find('textarea').ckeditor();

    this.draft_button = Ladda.create(this.$el.find('#reading-form-draft')[0]);
    this.publish_button = Ladda.create(this.$el.find('#reading-form-publish')[0]);

    return this;
  },

  saveAsDraft: function (e) {
    this.draft_button.start();
    return false;
  },

  saveAsPublished: function (e) {
    this.publish_button.start();
    return false;
  }
});