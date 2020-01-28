function adjustBodyWidth() {
  var w, delta = 0;
  $(".a-IRR-table").each(function() {
      var d = $(this).width() - $(this).parent().width();
      if ( d > delta ) {
        delta = d;
      }
  });

  if ( delta > 0 ) {
    w = $("body").width();
    $("body").width(w + delta);
  }
}

function init_plugin(){
  adjustBodyWidth();

  $(window).on("apexwindowresized", function() {
    adjustBodyWidth();
  });

  var lastX = 0;
   
  $(window).on("scroll", function() {
    var x = window.scrollX;
    if ( x !== lastX ) {
      lastX = x;
      $(".js-stickyWidget-toggle").each(function() {
        var sw$ = $(this),
        d = sw$.parent().offset().left - x;

        if ( sw$.hasClass("is-stuck")) {
          sw$.css("left", d + "px");
        } else {
          sw$.css("left", "");
        }
      });
    }
  });

  // sticky widgets aren't created yet so wait. Perhaps better to listen for create
  setTimeout(function() {
    $(".js-stickyWidget-toggle").each(function() {
      var sw$ = $(this);

      // these should be reall events not callbacks!
      sw$.stickyWidget("option", "onStick", function() {
        var d = sw$.parent().offset().left - window.scrollX;
        sw$.css("left", d + "px");
      });

      sw$.stickyWidget("option", "onUnstick", function() {
        sw$.css("left", "");
      });
    })
  }, 500);

  $("body").on("apexbeforerefresh", function() {
    $("body").css("width","");
  });

  $("body").on("apexafterrefresh", function() {
    adjustBodyWidth();
  });
}