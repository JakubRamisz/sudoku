class Board < ApplicationRecord
  has_many :fields, dependent: :destroy
  validates :name, presence: true
end
