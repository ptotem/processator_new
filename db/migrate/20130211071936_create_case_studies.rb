class CreateCaseStudies < ActiveRecord::Migration
  def change
    create_table :case_studies do |t|
      t.string :name
      t.text :description
      t.has_attached_file :avatar

      t.timestamps
    end
  end
end
