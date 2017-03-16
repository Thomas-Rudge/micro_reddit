document.addEventListener('turbolinks:load', function() {
  var updateKarma = function(objectDetails, karma) {
    var type = {"c": "comment", "p": "post"}[objectDetails[1]];
    var id = objectDetails.slice(2);
    var postId = $('#'+objectDetails).attr('data');

    if (postId == -1) {
      postId = id;
      id = null;
    };

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
      if (karma != 0) {
          points += karma;
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
        case 2:
          $upvoteSpan.addClass('upvoted');
          $karmaSpan.removeClass('downvoted');
          $karmaSpan.addClass('upvoted');
          $downvoteSpan.removeClass('downvoted');
          break;
        case -1: //Highlight downvote
        case -2:
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
    var $target = $(e.target);
    var $dtarget = $('#d'+this.id.slice(1));
    if ($target.hasClass('upvoted')) {
      updateKarma(this.id, 0);
    } else if ($dtarget.hasClass('downvoted')) {
      updateKarma(this.id, 2);
    } else {
      updateKarma(this.id, 1);
    };
  });

  $('.downvote').on('click', function(e) {
    e.preventDefault();
    var $target = $(e.target);
    var $utarget = $('#u'+this.id.slice(1));
    console.log($utarget);
    if ($target.hasClass('downvoted')) {
      updateKarma(this.id, 0);
    } else if ($utarget.hasClass('upvoted')) {
      updateKarma(this.id, -2);
    } else {
      updateKarma(this.id, -1);
    };
  });
});
