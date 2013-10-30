#= require active_admin/base
#

$ ->

  $('[data-toggle-approve-for-user]').click ->
    cb = $(this)
    userId = cb.attr('data-toggle-approve-for-user')

    $.ajax({
      type: 'PUT',
      url: "/admin/users/#{userId}.json",
      data: {
        user: {
          approved: this.checked
        }
      },
      dataType: 'json',
      success: ->
        $('[data-toggle-approve-for-user=' + userId + ']')
          .parents('tr')
          .css(backgroundColor: 'lightyellow')
    })


  $('.admin_demos .statusbox')
    .attr('title', 'click to request rerender')
    .click ->
      el = $(this)
      id = el.parents('tr').children(':first').text()

      $.ajax({
        type: 'PUT',
        url: "/admin/demos/#{id}.json",
        data: {
          demo: {
            status: 'uploaded'
          }
        },
        dataType: 'json',
        success: ->
          el.removeClass('processing rendered').addClass('uploaded')
      })

