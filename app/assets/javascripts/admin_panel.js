AnimateShowButtons = {
  setup: function () {
    show_btns = $("a:contains('Show')");
    show_btns.each(function(index) {
      $(this).on("click", function() {
        $(this).html("" + (($(this).attr("aria-expanded") == "true") ? "Show More <i class='fa fa-angle-down'></i>" : "Show Less <i class='fa fa-angle-up'></i>"));
      });
    });
  }
}

AnimateEditButtons = {
  setup: function() {
    var edit_btns = $("a[id*='editButton']");
    edit_btns.each(function(index) {
      var show_id = "#showbtn_" + edit_btns[index].id.split("_")[0]
      $(this).on("click", function() {
        $(show_id).trigger("click");
      });
    });
  }
}

AnimateCancelButtons = {
  setup: function() {
    var cancel_btns = $("a[id*='_CancelEdit']");
    cancel_btns.each(function(index) {
      var show_id = "#showbtn_" + cancel_btns[index].id.split("_")[0]
      $(this).on("click", function() {
        $(show_id).trigger("click");
      });
    });
  }
}

AdminAnimations = {
  setup: function() {
    $(AnimateShowButtons.setup);
    $(AnimateEditButtons.setup);
    $(AnimateCancelButtons.setup);
  }
}
$(AdminAnimations.setup);