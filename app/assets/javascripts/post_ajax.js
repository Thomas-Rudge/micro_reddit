$('#post_link').on('input', function(e){
  e.preventDefault();
  var link = $('#post_link').val();

  $.get('/post_title', {url : link}, function(data, status) {
    if (status == 'success') {
      $('#suggested_title').text(data);
    };
  });
});

