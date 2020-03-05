$(document).ready(function() {

	//	Append a caret to any submenu in the navigation with children
	$('#navPrimary:first-child > li.dropdown > a.dropdown-toggle').each(function(index, element) {
		$(this).append('<b class="caret"></b>');
	});

	// $('#myTooltip').tooltip();

	// Example of how to append a lock icon to a restricted primary nav item
	//$('#navProtectedArea a').append('&nbsp;<i class="fa fa-lock"></i>');

	$('.back-to-top').on('click', function(e) {
		$('body,html').animate({
			scrollTop:0
		}, 800);
		return false;
	});	

});

if($('#preloader').length > 0) {
	$(window).on("load", function() {		
		$('#preloader').fadeOut(500, function() {
			$('#preloader').remove();
		});
		// setTimeout(function() {}, 1000); 	  
	});
}
