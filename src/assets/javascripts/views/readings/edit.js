views = window.views || {};

views.ReadingEditView = Backbone.View.extend({
  initialize: function () {
    this.render().el;
    this.model.bind('save', this.render, this);
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

  saveModel: function (is_draft) {
    var view = this;
    var title = this.$el.find('#reading-form-title').val();

    if (title.length === 0) {
      this.draft_button.stop().enable();
      this.publish.stop().enable();
      return false;
    }

    this.model.set({
      'title': title,
      'content' : this.$el.find('#reading-form-content').val(),
      'draft' : is_draft
    });

    this.model.save(this.model.attributes, {
      success: function () {
        view.resetButtons();
        view.model.unset('year');
        view.render().el;
      }
    });
  },

  saveAsDraft: function (e) {
    this.draft_button.start();
    this.publish_button.disable();

    this.saveModel(true);
    return false;
  },

  saveAsPublished: function (e) {
    this.publish_button.start();
    this.draft_button.disable();

    this.saveModel(false);
    return false;
  },

  resetButtons: function () {
    this.publish_button.stop().enable();
    this.draft_button.stop().enable();
  }
});