$(function(){
	'use strict';

	// preloader
	$(".preloader").fadeOut();

	// sidebar
	$('.sidebar').sideNav();

	// slider
	$(".slide-show").owlCarousel({
		items: 1,
		navigation: true,
		slideSpeed: 1000,
		dots: true,
		paginationSpeed: 400,
		singleItem: true,
		autoplay: true,
		loop: true
	});

	// testimonial
	$(".testimonial").owlCarousel({
		items: 1,
		navigation: true,
		slideSpeed: 1000,
		dots: true,
		paginationSpeed: 400,
		singleItem: true,
		autoplay: true,
		loop: true
	});

	// smooth scroll
    $("a").on('click', function(event) {

      if (this.hash !== "") {
        event.preventDefault();

        var hash = this.hash;

        $('html, body').animate({

          scrollTop: $(hash).offset().top

        }, 850, function(){

          window.location.hash = hash;

        });

      }

    });

	// tabs
	$('ul.tabs').tabs();

	// collapse
	$('.collapsible').collapsible();

});