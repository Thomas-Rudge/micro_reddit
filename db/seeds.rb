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

# Taken from reddit
subs = ["announcements", "Art", "AskReddit", "askscience", "aww", "blog", "books", "creepy",
        "dataisbeautiful", "DIY", "Documentaries", "EarthPorn", "explainlikeimfive", "food",
        "funny", "Futurology", "gadgets", "gaming", "GetMotivated", "gifs", "history", "IAmA",
        "InternetIsBeautiful", "Jokes", "LifeProTips", "listentothis", "mildlyinteresting",
        "movies", "Music", "news", "nosleep", "nottheonion", "OldSchoolCool", "personalfinance",
        "philosophy", "photoshopbattles", "pics", "science", "Showerthoughts", "space", "sports",
        "television", "tifu", "todayilearned", "TwoXChromosomes", "UpliftingNews", "videos",
        "worldnews", "WritingPrompts", "popular", "all", "AskReddit", "funny", "videos", "pics",
        "worldnews", "todayilearned", "gifs", "gaming", "news", "aww", "movies", "mildlyinteresting",
        "television", "Showerthoughts", "dataisbeautiful", "nottheonion", "Jokes", "OldSchoolCool",
        "LifeProTips", "EarthPorn", "Music", "food", "tifu", "space", "IAmA", "personalfinance",
        "WritingPrompts", "photoshopbattles", "sports", "Futurology", "science", "explainlikeimfive",
        "UpliftingNews", "books", "TwoXChromosomes", "Art", "creepy", "DIY", "GetMotivated",
        "nosleep", "history", "gadgets", "askscience", "Documentaries", "InternetIsBeautiful",
        "listentothis", "philosophy"]

subs.each { |sub| FactoryGirl.create(:subreddit, name: sub) }

reddit = Nokogiri::HTML(open("https://www.reddit.com")
links  = reddit.css("div.entry")

links.each do |link|
  if url.start_with? "/r/"
    url = nil
    post_type = :text_post
  else
    url = link.children[0].children[0][:href]
    post_type = :link_post
  end

  FactoryGirl.create(post_type,
                     title:     link.children[0].children[0].text,
                     link:      url,
                     thumbnail: get_metadata(link)[:thumbnail])
end

