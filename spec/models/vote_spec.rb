require 'rails_helper'

RSpec.describe Vote, type: :model do

  it { is_expected.to validate_presence_of(:user_id) }
  it { is_expected.to validate_presence_of(:post_id) }
  it { is_expected.to validate_presence_of(:vote)    }
  it { is_expected.to validate_inclusion_of(:vote).in_array([ 0, 1 ]) }

  it { is_expected.to belong_to(:comment) }
  it { is_expected.to belong_to(:post)    }
  it { is_expected.to belong_to(:user)    }
end
