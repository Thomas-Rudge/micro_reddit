$(document).ready(function() {
  $('#new_post').css({'background':'red'});
  $('#post_link').change(getTitle(this.val));
  $(h3).click(alert("This is doing something"))

  var getTitle = function(url){

    $.get(
      url: "/post_title",
      data: {"url" : url},
      success: updateTitle
      dataType: String
    );
  };

  var updateTitle = function(data) {
    $('#suggested_title').val(data);
    };
};
