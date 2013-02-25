class CreateCaseStudiesUsers < ActiveRecord::Migration
  def change
    create_table :case_studies_users do |t|
      t.integer :case_study_id
      t.integer :user_id

      t.timestamps
    end
  end
end
