class AddColumnLabelToHierarchies < ActiveRecord::Migration
  def change
    add_column :hierarchies, :label, :string
  end
end
