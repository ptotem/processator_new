class AddColumnShapeAndTimeToSteps < ActiveRecord::Migration
  def change
    add_column :steps, :shape, :string
    add_column :steps, :time, :integer
  end
end
