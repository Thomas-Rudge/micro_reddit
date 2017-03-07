require 'rails_helper'

FactoryGirl.factories.map(&:name).each do |factory_name|
  describe "The #{factory_name} factory" do
     it 'is valid' do
       next if factory_name == :post
       if [:link_post, :text_post, :comment].include? factory_name && false
         user = FactoryGirl.build(:user)
         sub  = FactoryGirl.build(:subreddit)
         user.save
         sub.save
         user.subreddits << sub

         if factory_name == :comment
           post = FactoryGirl.build(:post, user_id: user.id, subreddit_id: sub.id)
           post.save

           FactoryGirl.build(:comment, user_id: user.id, post_id: post.id).should be_valid
         else
           FactoryGirl.build(factory_name, user_id: user.id, subreddit_id: sub.id).should be_valid
         end
       else
         FactoryGirl.build(factory_name).should be_valid
       end
     end
  end
end

