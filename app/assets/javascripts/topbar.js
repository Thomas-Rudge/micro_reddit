document.addEventListener('turbolinks:load', function() {
  var $mySubreddits = $('#my_subreddits');
  var $mySubredditList = $('#my_subreddit_list')

  $mySubreddits.on('click', function(e) {
    e.preventDefault();
    $mySubredditList.slideToggle('fast');
  });
});
