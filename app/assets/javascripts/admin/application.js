/* DO NOT MODIFY. This file was compiled Sun, 31 Jul 2011 05:50:56 GMT from
 * /Users/viper/projects/1337demos.com/1337demos-platform/app/coffeescripts/admin/application.coffee
 */

(function() {
  $(function() {
    $('[data-toggle-approve-for-user]').live('click', function() {
      var cb, userId;
      cb = $(this);
      userId = cb.attr('data-toggle-approve-for-user');
      return $.ajax({
        type: 'PUT',
        url: "/admin/users/" + userId + ".json",
        data: {
          user: {
            approved: this.checked
          }
        },
        dataType: 'json',
        success: function() {
          return $('[data-toggle-approve-for-user=' + userId + ']').parent().css({
            backgroundColor: 'lightyellow'
          });
        }
      });
    });
    return $('#demos .statusbox').attr('title', 'click to request rerender').click(function() {
      var el, id;
      el = $(this);
      id = el.parents('tr').children(':first').text();
      return $.ajax({
        type: 'PUT',
        url: "/admin/demos/" + id + ".json",
        data: {
          demo: {
            status: 'uploaded'
          }
        },
        dataType: 'json',
        success: function() {
          return el.removeClass('processing rendered').addClass('uploaded');
        }
      });
    });
  });
}).call(this);
