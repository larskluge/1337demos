jQuery(function($) {
  $('.shoutboxes-index .destroy a, .comments-index .destroy a').click(function() {
    var lnk = $(this);

    $.ajax({
      url: lnk.attr('href'),
      type: 'DELETE',
      dataType: 'json',
      success: function() {
        lnk.parent().parent().find('td').css('text-decoration', 'line-through');
      }
    });

    return false;
  });

  $("a[data-rerender]").live("ajax:success", function() {
    $(this).parent().text("Requested.");
  });
});

