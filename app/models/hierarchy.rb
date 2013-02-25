class Hierarchy < ActiveRecord::Base
  attr_accessible :son_id, :step_id, :label
  belongs_to :step
  belongs_to :son, :class_name =>'Step'
end
