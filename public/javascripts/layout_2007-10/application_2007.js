function getNumber(element)
{
	if(no = element.identify().match(/^map_link_([0-9]+)$/))
		return no[1];
	return 0;
}

function fadeIn(no, x, y)
{
	var div = new Element('div', { 'id': 'map_preview' + no, 'class': 'map_preview' });
	div.setStyle({'opacity': 0.0, left: x + 'px', top: y + 'px'});

	var imgurl = '/images/maps/thumbs/200x150/' + no + '.jpeg';
	var img = document.createElement('img');
	img.setAttribute('src', imgurl);

	div.appendChild(img);
	document.body.appendChild(div);

	Event.observe(div, 'mouseout', function(event) {
		fadeOutAll();
	});

	new Effect.Opacity(div, {duration:0.3, from:0.0, to:1.0});
}

function fadeOutAll()
{
	$$('.map_preview').each(function(elem) {
		new Effect.Opacity(elem, {duration:0.3, from: elem.getStyle('opacity'), to:0.0,
			afterFinish:function(obj)
			{
				var e = $(elem.getAttribute('id'));
				if(e)
					e.remove();
			}
		});
	});
}

function updateMapLinks()
{
	$$('.map_link').each(function(elem) {
		Event.observe(elem, 'mouseover', function(event) {
			var no = getNumber(Event.element(event));
			if(no > 0)
			{
				var x = 10 + Event.pointerX(event);
				var y = 10 + Event.pointerY(event);

				fadeIn(no, x, y);
			}
		});
		Event.observe(elem, 'mouseout', function(event) {
			fadeOutAll();
		});
	});
}


Event.observe(window, 'load', function() {
	updateMapLinks();


	Element.addMethods({
			visibility: function(elem, status) {
				elem = $(elem);
				elem.setStyle({'visibility': (status ? 'visible' : 'hidden')});
				return elem;
			},
			setWidth: function(elem, w) {
				return $(elem).setStyle({width: parseInt(w) + 'px'});
			},
			setHeight: function(elem, h) {
				return $(elem).setStyle({height: parseInt(h) + 'px'});
			}
	});


	function getContentWidth()
	{
		var c = $('content');
		return c.getWidth() - parseInt(c.getStyle('padding-left')) - parseInt(c.getStyle('padding-right'))
			 - parseInt(c.getStyle('border-left-width')) - parseInt(c.getStyle('border-right-width'));
	}

	function makeNewSlide()
	{
		var w = getContentWidth();
		return new Element('div').setStyle({'float': 'left'}).setWidth(w);
	}

	function updateContentWidth()
	{
		var w = getContentWidth();
		$('content').firstDescendant().childElements().each(function(e) {
			e.setWidth(w);
		});
	}

	Event.observe(window, 'resize', function() { updateContentWidth(); });




	// move content childs to new slide
	var parent = new Element('div').setWidth(10000);
	var slide = makeNewSlide();
	$('content').childElements().each(function(e) { slide.appendChild(e); });
	$('content').update(parent.update(slide)).makePositioned();


	function getContentLinks()
	{
		return $$('a[href]').collect(function(e) {
			var href = e.getAttribute('href');
			if((!href.match(/^https?:\/\//i)                            // no external links
				|| href.match(/^http:\/\/(www\.)?1337demos\.com/i))       // absolute internal links are ok
				&& !href.match(/\.(wd9|wd10|xml)$/i)                      // exclude download wdX files
				&& !href.match(/\?/))                                     // exclude urls with additional get parameters
			{
				return e;
			}
			return null;
		}).compact();
	}


	function updateContentLinks()
	{
		getContentLinks().each(function(e) {
			var href = e.getAttribute('href');
			if(!href.match(/^(javascript:)|#/i))
			{
				e.observe('click', function(e) {

					// effect on clicked link
					//new Effect.Pulsate();

					// change active menu entry
					if(e.element().descendantOf('nav'))
					{
						$$('#nav a').each(function(a) {
							a.removeClassName('active');
						});
						e.element().addClassName('active');
					}

					if(!href.match(/partial$/i))
					{
						//href += (href.match(/\?/)) ? '&' : '?';
						//href = '/partials' + href;

						if(!href.match(/\/$/))
							href += '/';

						href += 'partial';
					}

					var dest = makeNewSlide().setOpacity(0.0);
					parent.appendChild(dest);
					var loading = new Element('img', { width: 18, height: 15, src: "/images/loading_mini.gif" }).setStyle({verticalAlign: 'middle', margin: '3px'});
					new Ajax.Updater(dest, href, {
						method: 'get',
						asynchronous: true,
						evalScripts: true,
						onCreate: function(request) {
							e.element().insert(loading, { position: 'after' });
						},
						onComplete: function(request) {
							loading.remove();

							var childs = parent.childElements();
							if(childs.length == 2)
							{
								var oldone = $(childs.first());
								var newone = $(childs.last());

								new Effect.Fade(oldone, {
									duration: 0.25,
									afterFinish: function() {
										new Effect.Appear(newone, {duration: 0.25});

										parent.removeChild(oldone);
										updateContentWidth();
										updateContentLinks();
										updateMapLinks();
									}
								});
							}


							/*
							new Effect.Move(parent, {
									x: -1 * getContentWidth(),
									mode: 'relative',
									duration: 0.5,
									queue: { position: 'end', scope: '1337demos:pageslids' },
									afterFinish: function() {
										var src = dest.previous();

										src.hide();
										parent.setStyle({'left': '0px'});
										parent.removeChild(src);

										updateContentWidth();
										updateContentLinks();
										updateMapLinks();
									}
							});
							*/
						}
					});
					return false;
				});

				e.setAttribute('href', 'javascript:;//' + href);
			}
		});
	}

	//updateContentLinks();
});

