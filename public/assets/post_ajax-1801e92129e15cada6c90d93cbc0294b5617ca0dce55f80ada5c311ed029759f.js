$(document).ready(function() {
  var typingTimer;
  var doneTypingInterval = 1500;
  var $linkInput = $('#post_link');
  var $dynamicTitle = $('.dynamic_title');
  var $postTextBox = $('#post_text_box');
  var $postLinkBox = $('#post_link_box')
  var $postText = $('#post_post_text');
  var $suggestedTitle = $('#suggested_title');
  var $postThumb = $('#post_thumbnail');
  var $postTitle = $('#post_title')

  $linkInput.on('input propertychange paste', function () {
    clearTimeout(typingTimer);
    typingTimer = setTimeout(nowFetchTitle, doneTypingInterval);
  });

  function nowFetchTitle(){
    var link = $linkInput.val();

    if (link == '') {
      $dynamicTitle.slideUp();
      $postTextBox.slideDown();
    } else {
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
    };
  };

  $('#use_suggested_title').on('click', function(e) {
    e.preventDefault();
    var title = $suggestedTitle.text();
    console.log('Title: ' + title)
    $postTitle.val(title);
  });

  $postText.on('input propertychange paste', function() {
    var postInput = $postText.val()

    if (postInput == '') {
      $postLinkBox.slideDown();
    } else {
      $postLinkBox.slideUp();
    };
  });
});
