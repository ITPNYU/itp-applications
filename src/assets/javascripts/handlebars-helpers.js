Handlebars.registerHelper('shortDate', function(timestamp) {
  return moment(timestamp).format('M/D')
})

Handlebars.registerHelper('time', function(timestamp) {
  if (timestamp === null) {
    return "n/a";
  } else {
    return moment(timestamp).format('MMM Do h:mma');
  }
});

Handlebars.registerHelper('posturl', function (t) {
  var netid = $('body').data().netid;
  return "/students/"+netid+"/"+t.id+"/" + t.slug;
});

Handlebars.registerHelper('announcementurl', function (t) {
  return "/announcements/"+t.year+"/" + t.id;
});
