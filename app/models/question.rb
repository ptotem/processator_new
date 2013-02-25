class Question < ActiveRecord::Base
  attr_accessible :correct, :description, :optionA, :optionB, :optionC, :step_id
  belongs_to :step
end
