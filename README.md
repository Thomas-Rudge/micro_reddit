# MICRO REDDIT

Ruby  2.3.0

Rails 5.0.1

---

To get started

```bash
bundle install --without production
```

To test

```bash
bundle exec rspec spec
```
---

How to use the models.

```ruby
user = User.create(name: "joebloggs",
                   password: "password",
                   password_confirmation: "password")

sub = Subreddit.create(name: "learnruby",
                       description: "A place to learn",
                       nsfw: false)

# Have a user subscribe to a subreddit.

user.subreddits << sub

# This will create a subscription record.

user.subreddits
 => #<ActiveRecord::Associations::CollectionProxy [#<Subreddit id: 1, name: "learnruby", description: "A place to learn", nsfw: false, created_at: "2017-02-10 10:34:00", updated_at: "2017-02-10 10:34:00

user.subscriptions
 => => #<ActiveRecord::Associations::CollectionProxy [#<Subscription id: 1, user_id: 1, subreddit_id: 1, created_at: "2017-02-10 10:34:09", updated_at: "2017-02-10 10:34:09">]>

# From the subreddits perspective.

sub.users
 => #<ActiveRecord::Associations::CollectionProxy [#<User id: 1, name: "joebloggs", password_digest: "$2a$10$E8R9wtDdZRxdR093k.CjzOx7XwLcVShnQnX1NhE25xT...", created_at: "2017-02-10 10:33:24", updated_at: "2017-02-10 10:33:24">]>

sub.subscriptions
 => #<ActiveRecord::Associations::CollectionProxy [#<Subscription id: 1, user_id: 1, subreddit_id: 1, created_at: "2017-02-10 10:34:09", updated_at: "2017-02-10 10:34:09">]>

# Making Posts
# (A post requires at least 1 user and 1 subreddit to exist in the system.)

# A link post
post = Post.new(title: "Check out this cool site!",
                link: "www.rubyonrails.org",
                post_type: 1)

# A self/text post
post = Post.new(title: "DAE TDD?",
                post_text: "It can't just be me!",
                post_type: 0)

# Assign the post to a user and a subreddit, then save.
post.user_id      = user.id
post.subreddit_id = sub.id

post.save
 => true

# As expected, you can access the posts from either the user or subreddit.
user.posts
sub.posts
 => #<ActiveRecord::Associations::CollectionProxy [#<Post id: 1, title: "Check out this cool site!", link: "http://www.rubyonrails.org", post_text: nil, post_type: 1, user_id: 1, subreddit_id: 1, created_at: "2017-02-10 10:43:00", updated_at: "2017-02-10 10:43:00">]> 

# Adding comments
comment = Comment.new(content: "OMG you're such a newb!")
comment.post_id = post.id
# A user doesn't have to be subscribed to a post's subreddit to comment on it.
comment.user_id = 2
comment.save
 => true

user2.comments
post.comments
 =>  => #<ActiveRecord::Associations::CollectionProxy [#<Comment id: 1, content: "OMG you're such a newb!", post_id: 1, user_id: 2, created_at: "2017-02-10 10:52:04", updated_at: "2017-02-10 10:52:04">]>
```

---

//TODO

* Create controllers

* Create views

* Add to model functionality
