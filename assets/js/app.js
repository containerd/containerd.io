function showIfPastThreshold(threshold, element) {
  const position = $(document).scrollTop();

  if (position > threshold) {
    element.show();
  }
}

function arrowUp() {
  $('.is-arrow-up').click(function() {
    $('html,body').animate({
      scrollTop: 0
    }, 'slow');
  });
}

function addAnchors() {
  const selectors = '.is-inner-content h2, .is-inner-content h3, .is-inner-content h4';

  anchors.options = {
    icon: '#'
  }

  anchors.add(selectors);
}

function linkClickOffset() {
  const navbarHeight = $('.navbar').height();
  const extraPadding = 20;
  const navbarOffset = -1 * (navbarHeight + extraPadding);
  var shiftWindow = function() { scrollBy(0, navbarOffset) };
  window.addEventListener("hashchange", shiftWindow);
  window.addEventListener("pageshow", shiftWindow);
  function load() { if (window.location.hash) shiftWindow(); }
}

function tableOfContents() {
  const container = $('.is-toc-container');
  const threshold = container.offset().top - 100;

  if ($(document).scrollTop() > threshold) {
    container.addClass('is-active');
  }

  $(window).on('scroll', function() {
    if ($(document).scrollTop() > threshold) {
      container.addClass('is-active');
    } else {
      container.removeClass('is-active');
    }
  });
}

function docsDropdown() {
  $('.is-docs-page .dropdown').click(function() {
    $(this).toggleClass('is-active');
  });
}

function docsNavbarTitleToggle() {
  const title = $('.is-docs-title'),
        threshold = $('.navbar').height() + $('.hero').height();

  title.hide();

  showIfPastThreshold(threshold, title);

  $(window).on('scroll', function() {
    const position = $(document).scrollTop();

    if (position > threshold) {
      title.fadeIn();
    } else {
      title.fadeOut();
    }
  });
}

function navbarBurgerToggle() {
  $('.navbar-burger').click(function() {
    $('.navbar-burger').toggleClass('is-active');
    $('.navbar-menu').toggleClass('is-active');
  });
}

$(function() {
  console.log("Welcome to the containerd website and documentation!");

  linkClickOffset();
  docsNavbarTitleToggle();
  navbarBurgerToggle();
  docsDropdown();
  tableOfContents();
  addAnchors();
  arrowUp();
});
