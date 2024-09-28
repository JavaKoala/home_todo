class AddDoneToTodos < ActiveRecord::Migration[7.2]
  def change
    add_column :todos, :done, :boolean, default: false, null: false
  end
end
