$(function(){
	'use strict';

	// filterizr
	$('.filtr-container').filterizr();

	// gallery filter
    $('.portfolio-menu li').click(function() {
        $('.portfolio-menu li').removeClass('active');
        $(this).addClass('active');
    });

});