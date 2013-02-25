class CreateOperations < ActiveRecord::Migration
  def change
    create_table :operations do |t|
      t.string :name
      t.text :description
      t.has_attached_file :avatar

      t.timestamps
    end
  end
end
