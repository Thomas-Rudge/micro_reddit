require 'rails_helper'

RSpec.describe Subscription, type: :model do

  it { is_expected.to belong_to(:subreddit).counter_cache(true) }
  it { is_expected.to belong_to(:user) }
end
