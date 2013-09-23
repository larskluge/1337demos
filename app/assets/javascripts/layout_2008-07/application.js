// extend jQuery
jQuery.fn.wait = function(delay) {
  delay = delay || 1000;
  return this.animate({opacity: this.css('opacity')}, delay);
};


jQuery.fn.as_html_nickname = function() {
  var name = $.trim(($(this).text() || $(this).val() || ""));

  if(!name) {
    return "";
  }

  return '<span class="c7">' +
    name
      .replace(/\^([^\^])/g, "</span><span class=\"c$1\">")
      .replace(/class=\"c[^0-9][^\"]*\"/, 'class="c0"')
      .replace(/\^\^/g, "^") +
    "</span>";
};





function applyAjaxRating(rating)
{
  rating = $(rating);
  if(rating.length === 0) {
    return;
  }

  var type = 'POST';
  var url = jQuery('form', rating).attr('action');
  var data = jQuery.makeArray(
    jQuery.map(
      jQuery('input[type=hidden]', rating), function(e) { return $(e).attr('name') + '=' + $(e).attr('value'); }
    ));
  data.push('rating[amount]=');
  data = data.join('&');

  jQuery('input[type=submit]', rating).click(function() {

    var amount = jQuery('form select', rating).get(0).selectedIndex;

    jQuery.ajax({
      type: type,
      url: url,
      data: data + amount,
      success: function(data, textStatus) {
        // data could be xmlDoc, jsonObj, html, text, etc...

        console.log('success: ' + textStatus);
      },
      error: function(XMLHttpRequest, textStatus, errorThrown) {
        // typically only one of textStatus or errorThrown
        // will have info

        console.log('error: ' + textStatus);
      }
    });

    return false;
  });
}






function common_content()
{
  // flash message
  $('#notice_div_id').wait(1000).animate({color: 'red'}, 500).animate({color: 'green'}, 500).wait(3000).slideUp(1000);


  // animate links
  var stdbgcolor = '#CCCCCC';

  $(".content a").each(function() {
    if($(this).css('border-bottom-color') == 'transparent') {
      $(this).addClass("animate-link");
    }
  });

  $('.content a.animate-link').live("mouseover", function() {
    $(this).animate({borderBottomColor: '#006DCB'}, 'normal');
  });

  $('.content a.animate-link').live("mouseout", function() {
    $(this).animate({borderBottomColor: stdbgcolor}, 'slow', 'linear', function() {
      $(this).css('border-bottom-color', 'transparent');
    });
  });

  // open external links in new window
  $('a[rel~="external"]').attr('target', '_blank');

  // enable tip-tip tooltips
  $(".content [title]").tipTip({edgeOffset: 5});


  var nickname = $('[data-player=name]');
  if(nickname.length > 0) {
    var updatePreview = function() {
      $(this).next(".preview").html("Preview: " + $(this).as_html_nickname());
    };

    var preview = $('<div>', {"class": "preview"});
    nickname.after(preview);

    nickname.change(updatePreview);
    nickname.keyup(updatePreview);
    $.proxy(updatePreview, nickname)();
  }
}

function common_layout()
{
  // change nav before page loading
  //
  $(".nav > li > a").click(function() {
    $(".nav > li.active").removeClass("active");
    $(this).parent("li").addClass("active");
  });

  // nav bg sprite animation
  //
  $('.nav > li:not(.active) > a')
    .css({backgroundPosition: "0 0"})
    .mouseover(function() {
      $(this).stop().animate(
        {backgroundPosition:"-600px 0"},
        {duration:300});
    })
    .mouseout(function() {
      $(this).stop().animate(
        {backgroundPosition:"0px 0"},
        {duration:500});
    })
    .click(function() {
      $(this).unbind("mouseout");
    });



  // set footer content opacity
  var semi = 0.5;
  $('.footer a').css('opacity', semi).hover(function() {
    $(this).fadeTo('slow', 1);
  }, function() {
    $(this).fadeTo('slow', semi);
  });
}



function home()
{
  // just show first x news entries
  var show_n_entries = 5;
  var hidden_entries = $('#news div:gt('+(show_n_entries*2-1)+')');
  hidden_entries.hide();

  // append show all news-button
  var showallbtn = $('<p><a href="#">more</a></p>').appendTo('#news');
  showallbtn.click(function() {
    hidden_entries.fadeIn('slow');
    showallbtn.hide();
    return false;
  });


  // init shoutbox
  if($('#shoutbox_container_toggle .errorExplanation').length === 0) {
    $('#shoutbox_container_toggle').hide();
  }
  $('#toggle').click(function() {
    // toggle display of container
    //
    $('#shoutbox_container_toggle').toggle('normal', function() {
      // focus first empty input field
      //
      $(this).find("input.text[value=''], textarea").first().focus();
    });
  });
}

function demos()
{
  // add a preview image on mouseover to map links
  $('.map_link').mouseover(function(event) {
    var res = $(this).attr('class').match(/map_link_(\d+)/);
    if(res.length > 1)
    {
      var no = res[1];
      var imgurl = '/images/maps/thumbs/200x150/' + no + '.jpeg';
      var div = jQuery('<div class="map_preview"><img src="'+imgurl+'" width="200" height="150" alt="" /></div>');
      div.hide();

      var x = event.pageX + 10;
      var y = event.pageY + 10;
      div.css({left: x + 'px', top: y + 'px'});

      $(this).mouseout(function() {
        div.fadeOut('normal');
      });

      div.appendTo('body');
      div.fadeIn('normal');

    }
  });


  // animate comment form on demos details
  if($('#demo_comments_form_body .errorExplanation').length === 0) {
    $('#demo_comments_form_body').hide();
  }
  $('#demo_comments_form_head a:first').click(function() {
    $('#demo_comments_form_body').toggle('normal');
  });

  // embed_code: select complete source code on click
  $('#embed_code').click(function() {
    $(this).focus();
    $(this).select();
  });



  applyAjaxRating('.rating');
}



jQuery(function() {
  home();
  demos();

  common_content();
  common_layout();
});

