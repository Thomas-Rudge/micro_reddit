$(document).ready(function() {

  var updateKarma = function(objectDetails, karma) {
    var type = {"c": "comment", "p": "post"}[objectDetails[1]];
    var id = objectDetails.slice(2);
    var postId = $('#'+objectDetails).attr('data');

    $.post('/karma', {id: id, type: type, karma: karma, postid: postId}, function(data, status) {
      console.log('Karma>'+karma);
      if (status != 'success') {
        return null;
      };

      var $upvoteSpan = $('#u'+objectDetails.slice(1));
      var $downvoteSpan = $('#d'+objectDetails.slice(1));
      var $karmaSpan = $('#k'+objectDetails.slice(1));
      var points = parseInt($karmaSpan.text(), 10);
      // If user clicks upvote with downvote highlighted, or
      // visa-versa, the vote count should change by 2.
      if ([1, -1].includes(karma)) {
        if (karma == 1 && $downvoteSpan.hasClass('downvoted')){
          points += 2;
        } else if (karma == -1 && $upvoteSpan.hasClass('upvoted')){
          points -= 2;
        } else {
          points += karma;
        };
      } else if (objectDetails[0] == 'u') {
        --points;
      } else {
        ++points;
      };
      //
      switch(karma) {
        case 0: //Remove all highlighting
          $upvoteSpan.removeClass('upvoted');
          $downvoteSpan.removeClass('downvoted');
          $karmaSpan.removeClass('upvoted downvoted');
          break;
        case 1: //Highlight upvote
          $upvoteSpan.addClass('upvoted');
          $karmaSpan.removeClass('downvoted');
          $karmaSpan.addClass('upvoted');
          $downvoteSpan.removeClass('downvoted');
          break;
        case -1: //Highlight downvote
          $downvoteSpan.addClass('downvoted');
          $karmaSpan.removeClass('upvoted');
          $karmaSpan.addClass('downvoted');
          $upvoteSpan.removeClass('upvoted');
          break;
      };
      //Update points
      $karmaSpan.text(points.toString());
    });
  };

  $('.upvote').on('click', function(e) {
    e.preventDefault();
    if ($(e.target).hasClass('upvoted')) {
      updateKarma(this.id, 0);
    } else {
      updateKarma(this.id, 1);
    };
  });

  $('.downvote').on('click', function(e) {
    e.preventDefault();
    if ($(e.target).hasClass('downvoted')) {
      updateKarma(this.id, 0);
    } else {
      updateKarma(this.id, -1);
    };
  });
});
