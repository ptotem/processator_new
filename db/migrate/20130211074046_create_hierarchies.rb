class CreateHierarchies < ActiveRecord::Migration
  def change
    create_table :hierarchies do |t|
      t.integer :step_id
      t.integer :son_id

      t.timestamps
    end
  end
end
