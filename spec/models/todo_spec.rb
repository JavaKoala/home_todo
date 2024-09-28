require 'rails_helper'

RSpec.describe Todo do
  it { is_expected.to belong_to(:list) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_presence_of(:due) }
end
