require 'rails_helper'

FactoryGirl.factories.map(&:name).each do |factory_name|
  describe "The #{factory_name} factory" do
    it 'is valid' do
      if factory_name == :comment
        post = FactoryGirl.build(:text_post)
        post.save
        factory = FactoryGirl.build(factory_name,
                                    user_id: post.user.id,
                                    post_id: post.id)
      else
        factory = FactoryGirl.build(factory_name)
      end

      unless factory.valid?
        factory.errors.full_messages.each { |msg| puts msg }
        factory.attributes.each { |key, val| puts "#{key} => #{val}"}
      end

      factory.should be_valid
    end
  end
end

