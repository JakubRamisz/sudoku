class Board < ApplicationRecord
  has_many :fields
  validates :name, presence: true
end
