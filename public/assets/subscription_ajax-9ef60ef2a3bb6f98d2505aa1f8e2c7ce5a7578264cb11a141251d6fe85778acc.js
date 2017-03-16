$(document).ready(function() {
  $('.unsubscribe').on('click', function(e) {
    e.preventDefault();
    var $target = $(e.target);
    var id = $target.attr('data');
    $.post('/unsubscribe', {id: id}, function(data, status) {
      if (status == 'success') {
        $target.removeClass('unsubscribe');
        $target.addClass('subscribe');
      };
    });
  });

  $('.subscribe').on('click', function(e) {
    e.preventDefault();
    var $target = $(e.target);
    var id = $target.attr('data');
    $.post('/subscribe', {id: id}, function(data, status) {
      if (status == 'success') {
        $target.removeClass('subscribe');
        $target.addClass('unsubscribe');
      };
    });
  });
});
