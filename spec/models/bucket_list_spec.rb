require 'rails_helper'

RSpec.describe BucketList, type: :model do
  it { is_expected.to have_many(:items) }
  it { should validate_presence_of(:name) }
end
