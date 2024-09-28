class CreateTodos < ActiveRecord::Migration[7.2]
  def change
    create_table :todos do |t|
      t.text :description
      t.datetime :due
      t.references :list, null: false, foreign_key: true

      t.timestamps
    end
  end
end
