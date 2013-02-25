class Step < ActiveRecord::Base
  attr_accessible :avatar, :description, :name, :operation_id, :shape, :time
  has_attached_file :avatar
  belongs_to :operation
  has_many :hierarchies
  has_many :sons, :through => :hierarchies
  has_many :questions
  accepts_nested_attributes_for :hierarchies, :reject_if => lambda { |a| a[:son_id].blank? }
end
