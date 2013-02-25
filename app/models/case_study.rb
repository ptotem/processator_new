class CaseStudy < ActiveRecord::Base
  attr_accessible :avatar, :description, :name, :users
  has_attached_file :avatar
  has_and_belongs_to_many :users
  has_many :operations, :through => :operation_maps
  has_many :operation_maps
end
