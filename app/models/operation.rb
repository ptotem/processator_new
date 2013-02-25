class Operation < ActiveRecord::Base
  attr_accessible :avatar, :description, :name, :case_studies
  has_attached_file :avatar
  has_many :case_studies, :through => :operation_maps
  has_many :operation_maps
  has_many :steps
end
