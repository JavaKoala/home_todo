require 'rails_helper'

RSpec.describe Event do
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:start) }
  it { is_expected.to validate_presence_of(:end) }
end
