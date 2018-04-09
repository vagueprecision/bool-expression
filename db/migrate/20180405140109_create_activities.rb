class CreateActivities < ActiveRecord::Migration[5.1]
  def change
    create_table :activities do |t|
      t.string :key
      t.string :name
      t.boolean :sample_value

      t.timestamps
    end
  end
end
