class Task < ApplicationRecord
  belongs_to :project

  validates_presence_of :name
  validates_presence_of :status
end
