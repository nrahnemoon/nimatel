$(document).ready(function(){
	$('.carousel').carousel({
		interval: 3000
	});
	$('.carousel-control.left').click(function() {
		console.log("left");
		$('.carousel').carousel('prev');
	});
	$('.carousel-control.right').click(function() {
		console.log("right");
		$('.carousel').carousel('next');
	});
});

