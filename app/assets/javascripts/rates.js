$(document).ready(function(){
	if (!!$('.nm-rates--main')[0]) {
		$('.country-search').keyup(function(event) {
			$('.country-name').each(function() {
				var regExp = new RegExp($('.country-search').val(), 'i');
				if (regExp.test($(this).html())) {
					$(this).parent('tr').show();
				} else {
					$(this).parent('tr').hide();
				}
			});
		});
	}
});