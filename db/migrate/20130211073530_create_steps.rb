class CreateSteps < ActiveRecord::Migration
  def change
    create_table :steps do |t|
      t.string :name
      t.text :description
      t.has_attached_file :avatar
      t.integer :operation_id

      t.timestamps
    end
  end
end
