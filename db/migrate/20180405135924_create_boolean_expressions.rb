class CreateExpressions < ActiveRecord::Migration[5.1]
  def change
    create_table :expressions do |t|
      t.string :name
      t.string :expression

      t.timestamps
    end
  end
end
