class CaseStudiesUsers < ActiveRecord::Base
  attr_accessible :case_study_id, :user_id
  belongs_to :user
  belongs_to :case_study
end
