require 'rails_helper'

RSpec.describe List do
  it { is_expected.to have_many(:todos).dependent(:destroy) }
  it { is_expected.to validate_presence_of(:name) }
end
