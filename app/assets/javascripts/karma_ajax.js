$(document).ready(function() {
  var $postThumb = $('#post_thumbnail');
  var $postTitle = $('#post_title')

  var updateKarma = function(data,

    $.get('/post_title', {url : link}, function(data, status) {
      if (status == 'success') {
        if (data.title != '') {
          $dynamicTitle.slideDown();
          $suggestedTitle.text(data.title);
          $postThumb.val(data.thumbnail);
          $postTextBox.slideUp();
        } else {
          $suggestedTitle.text("");
          $postThumb.val("");
        };
      };
  });

  $('#use_suggested_title').on('click', function(e) {
    e.preventDefault();
    var title = $suggestedTitle.text();
    console.log('Title: ' + title)
    $postTitle.val(title);
  });

  $('.upvote').on('click', updateKarma(this.data, 1));
  $('.downvote').on('click', updateKarma(this.data, 0));
});
