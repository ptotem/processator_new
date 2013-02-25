class CreateOperationMaps < ActiveRecord::Migration
  def change
    create_table :operation_maps do |t|
      t.integer :case_study_id
      t.integer :operation_id
      t.integer :depth
      t.string :sequence

      t.timestamps
    end
  end
end
