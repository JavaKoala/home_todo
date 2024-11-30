require 'rails_helper'

RSpec.describe TodosHelper do
  describe '.todos_color' do
    it 'returns nil when the todo is done' do
      todo = Todo.new(done: true)

      expect(helper.todos_color(todo)).to be_nil
    end

    it 'returns nil when the todo is not done within a day' do
      todo = Todo.new(done: false, due: 1.day.from_now)

      expect(helper.todos_color(todo)).to be_nil
    end

    it 'returns darker green when the todo is not done within a day' do
      todo = Todo.new(done: false, due: 1.day.ago)

      expect(helper.todos_color(todo)).to eq 'bg-green-100 dark:bg-green-900'
    end

    it 'returns green when the todo is not done within two day' do
      todo = Todo.new(done: false, due: 2.days.ago)

      expect(helper.todos_color(todo)).to eq 'bg-green-50 dark:bg-green-950'
    end

    it 'returns red when the todo is not done within three day' do
      todo = Todo.new(done: false, due: 3.days.ago)

      expect(helper.todos_color(todo)).to eq 'bg-red-50 dark:bg-red-950'
    end

    it 'returns red when the todo is not done within 4 day' do
      todo = Todo.new(done: false, due: 4.days.ago)

      expect(helper.todos_color(todo)).to eq 'bg-red-100 dark:bg-red-900'
    end

    it 'returns red when the todo is not done within 5 day' do
      todo = Todo.new(done: false, due: 5.days.ago)

      expect(helper.todos_color(todo)).to eq 'bg-red-200 dark:bg-red-800'
    end
  end
end
