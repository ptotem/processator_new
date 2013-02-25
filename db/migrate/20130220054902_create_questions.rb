class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :step_id
      t.text :description
      t.text :optionA
      t.text :optionB
      t.text :optionC
      t.string :correct

      t.timestamps
    end
  end
end
