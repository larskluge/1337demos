// extend jQuery
jQuery.fn.wait = function(delay) {
	var delay = delay || 1000;
	return this.animate({opacity: this.css('opacity')}, delay);
};





function applyAjaxRating(rating)
{
	rating = $(rating);
	if(rating.length == 0)
		return false;

	var type = 'POST';
	var url = jQuery('form', rating).attr('action');
	var data = jQuery.makeArray(
		jQuery.map(
			jQuery('input[type=hidden]', rating), function(e) { return $(e).attr('name') + '=' + $(e).attr('value'); }
		)
	);
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





var stdbgcolor = '#CCCCCC';

function common_content()
{
	// Cachable flash
	Flash.transferFromCookies();
	Flash.writeDataTo('error', $('#error_div_id'));
	Flash.writeDataTo('notice', $('#notice_div_id'));
	$('#notice_div_id').wait(1000).animate({color: 'red'}, 500).animate({color: 'green'}, 500).wait(3000).slideUp(1000);

	// animate links
	$('.content a').each(function() {
		var elem = $(this);
		if(elem.css('border-bottom-color') == 'transparent')
		{
			//elem.hover(function() { elem.addClass('hover', 'slow'); }, function() { elem.removeClass('hover', 'slow'); });

			elem.hover(function() {
				elem.animate({borderBottomColor: '#006DCB'}, 'normal');
			},function() {
				elem.animate({borderBottomColor: stdbgcolor}, 'slow', 'linear', function() {
					elem.css('border-bottom-color', 'transparent');
				});
			});
		}
	});

	// open external links in new window
	$('a[rel=external]').attr('target', '_blank');
}

function common_layout()
{
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
	var showallbtn = $('<p><a href="#">Show all</a></p>').appendTo('#news');
	showallbtn.click(function() {
		hidden_entries.fadeIn('slow');
		showallbtn.hide();
		return false;
	});


	// init shoutbox
  if($('#shoutbox_container_toggle .errorExplanation').length === 0)
    $('#shoutbox_container_toggle').hide();
	$('#toggle').click(function() {
		$('#shoutbox_container_toggle').toggle('normal');
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
  if($('#demo_comments_form_body .errorExplanation').length === 0)
    $('#demo_comments_form_body').hide();
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

