include MetaDatasHelper
start = Time.now
puts "START ########"
puts "Creating users"
names = ["way_fairer", "StickleyMan", "_vargas_", "Unidan", "Iraniangenius", "awildsketchappeared",
         "Painmatrix", "straydog1980", "RamsesThePigeon", "-eDgaR-", "Jux_", "APOSTOLATE", "kijafa",
         "Thehealeroftri", "warlizard", "danrennt98", "smeeee", "Donald_Keyman", "dick-nipples",
         "Poem_for_your_sprog", "pepsi_next", "GallowBoob", "ibleeedorange", "1Voice1Life", "bubblr",
         "Libertatea", "isai76", "maxwellhill", "mepper", "lobo2ffs", "anutensil", "davidreiss666",
         "SlimJones123", "mike_pants", "ethan_kahn", "Proteon", "JimKB", "onlysame1", "Scopolamina",
         "Kevlaryarmulke", "ani625", "j0be", "dummystupid", "likwitsnake", "Mattryd7", "preggit",
         "arbili", "TheCannon", "horse_you_rode_in_on", "immorta1", "n8thegr8", "motha_effin_kitty_yo",
         "strallweat", "down_vote_magnet", "Editingandlayout", "mattythedog"]

names.each { |name| FactoryGirl.create(:user, name: name) }
puts "Users created"
puts "Creating subreddits"
# Taken from reddit
sublist = ["dataisbeautiful", "documentaries", "earthporn", "explainlikeimfive", "funny",
           "futurology", "gadgets", "history", "iama", "internetisbeautiful", "mildlyinteresting",
           "movies", "nottheonion", "pics", "science", "showerthoughts", "space", "aww",
           "todayilearned", "videos", "worldnews", "learnruby", "europe"]

sublist.each { |sub| FactoryGirl.create(:subreddit, name: sub, mod: [*(1..55)].sample) }

subs = Hash.new
Subreddit.all.each { |sub| subs[sub.name] = sub.id }
puts "Subreddits created"

#Get first three pages of each sub, should take 3 minutes (10 * 23)
reddits = Array.new
puts "Loading subreddit post data"
sublist.each do |sub|
  puts "  :>#{sub}"
  [0, 25, 50].each do |page|
    #html = open("https://www.reddit.com/r/#{sub}/?count=#{page}",
    #            "User-Agent"=>"MicroRedditSeeder:v0.0.1 (by /u/tomarse)",
    #            "From"=>"hello@thomasrudge.co.uk").read
    file = File.join(Rails.root, "db", "seed_data", "#{sub}#{page}.txt")
    html = File.open(file, "r") { |f| f.read }
    #File.open(file, 'w') { |f| f.write(html) }
    reddits << Nokogiri::HTML(html)
    #sleep(10)
  end
end
puts "Subreddit post data loaded"
puts "Extracting posts from data, and posting to subreddits"
reddits.each do |page|
  subreddit = page.css("link[rel='canonical']")[0][:href]
  subreddit = subreddit[subreddit.index("/r/")+3..-1].gsub("/","").downcase unless subreddit.nil?
  puts "  Posting to:> #{subreddit}"
  subreddit = subs[subreddit] ||= subs[sublist.sample]
  puts "  Sub ID    :> #{subreddit}"
  posts     = page.css("div.entry")
  posts.each do |post|
    link  = post.children[0].css("a.title")[0][:href]
    title = post.children[0].css("a.title")[0].text
    next if title.length > 255
    print "  Posting link:> #{link}".ljust(80) + "\r"

    post_type = (link.start_with? "/r/") ? :text_post : :link_post

    FactoryGirl.create(post_type,
                       title:        title,
                       link:         link,
                       thumbnail:    get_metadata(link)[:thumbnail],
                       subreddit_id: subreddit,
                       user_id:      [*(1..55)].sample) rescue nil
  end
end
puts "Nil subbed posts #{Post.where(subreddit_id: nil).count}"
puts "Post data posted"
# A lot of self posts where the bulk of details is in the post, which I can't get to :/
puts "Clearing out unwanted self-posts"
Post.where(subreddit_id: (Subreddit.where(name: ["dataisbeautiful",
                                                 "pics",
                                                 "aww",
                                                 "funny"])), post_type: 0).destroy_all
puts "Self-posts cleared"
# Have each user subscribe to some subreddits
puts "Subscribing users to subreddits"
User.all.each do |user|
  puts "  User:> #{user.name}"
  Subreddit.all.each do |sub|
    if [false, false, false, true].sample
      user.subreddits << sub
      puts "    subbed to:> #{sub.name}"
    end
  end
end
puts "Finished subsribing"
# Add comments to posts
puts "Commenting on posts"
Post.all.each do |post|
  print "Post ID: #{post.id}      \r"
  User.all.each do |user|
    if [false, false, true].sample
      FactoryGirl.create(:comment, user_id: user.id, post_id: post.id) rescue nil
    end
  end

  post.update_attribute(:comment_count, post.comments.count)
end
puts "Finished commenting"
# Since we bypassed the controller, update user karma
puts "Updating user karma"
User.all.each { |user| user.reset_karma }
puts "Karma updated"
puts "Seeding completed in #{((Time.now - start)/60).round(2)} minutes"
puts "END ########"
