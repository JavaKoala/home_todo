require 'rails_helper'

RSpec.describe Todo do
  it { is_expected.to belong_to(:list) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_presence_of(:due) }

  describe '.list_order' do
    it 'orders todos by done and due' do
      list = create(:list)
      todo1 = create(:todo, list: list, done: false, due: 1.day.from_now)
      todo2 = create(:todo, list: list, done: true, due: 2.days.from_now)
      todo3 = create(:todo, list: list, done: false, due: 3.days.from_now)

      expect(described_class.list_order(list)).to eq([todo1, todo3, todo2])
    end
  end
end
