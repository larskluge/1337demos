function Rating(rating)
{
	this.rating = $(rating);
	if(this.rating.length == 0)
		return false;

	this.maxStars = $('option:last', this.rating).attr('value');

	this.type = 'POST';
	this.url = jQuery('form', this.rating).attr('action');
	this.data = $('input[type=hidden]', this.rating).map(function(i, e) { return $(e).attr('name') + '=' + $(e).attr('value'); }).get();
	this.data.push('rating[amount]=');
	this.data = this.data.join('&');

	this.rebuildHTML();
}

Rating.prototype = {
	setCurrentRating: function(average) {
		var perc = average / this.maxStars * 100;
		$('.current-rating').css('width', perc + '%');
	},
	getRatingFromText: function(text) {
		var matches = text.match(/.*?([0-9\.]+)/i);
		return matches ? matches[1] : 0;
	},
	rebuildHTML: function() {
		//var selected = $('select option[selected]', this.rating).attr('value');
		//var selected = $('input[name=current_rating]', this.rating).attr('value');
		var ratingText = $('#current_rating', this.rating).text();
		var selected = this.getRatingFromText(ratingText);

		var out = '<ul>';

		var perc = selected / this.maxStars * 100;
		out += '<li class="current-rating" style="width: '+perc+'%"></li>';

		var self = this;
		$('option', this.rating).each(function(i, e) {
			var val = $(e).attr('value');
			var text = val + ' Sterne von ' + self.maxStars;
			out += '<li><a href="javascript:void(0)" onclick="rating.rate('+val+')" class="star'+val+'" title="'+text+'">';
			out += val;
			out += '</a></li>';
		});

		out += '</ul><div class="box"></div>';

		this.rating.html(out);
		this.status(ratingText);
	},
	rate: function(amount) {
		this.status('Updating...');
		jQuery.ajax({
			type: this.type,
			url: this.url,
			data: this.data + amount,
			success: function(data, textStatus) {

				var message = data;
				var average = rating.getRatingFromText(message);

				rating.setCurrentRating(average);
				rating.status(message);
			},
			error: function(XMLHttpRequest, textStatus, errorThrown) {
				// typically only one of textStatus or errorThrown
				// will have info

				rating.status(XMLHttpRequest.responseText);
			}
		});

		return false;
	},
	status: function(msg) {
		$('.box', this.rating).html(msg);
	}
};



var rating = null;
jQuery(function() {
	rating = new Rating('.rating');
});

