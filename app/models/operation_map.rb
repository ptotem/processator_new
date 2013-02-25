class OperationMap < ActiveRecord::Base
  attr_accessible :case_study_id, :depth, :operation_id, :sequence
  belongs_to :operation
  belongs_to :case_study
end
