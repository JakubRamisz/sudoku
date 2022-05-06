class Board < ApplicationRecord
  has_many :fields, dependent: :destroy
  validates :name, presence: true

  def safe?(number, row_index, column_index)
    row = fields.where(row: row_index)
    row.each do |field|
      if field.value.eql?(number)
        return false
      end
    end

    column = fields.where(column: column_index)
    column.each do |field|
      if field.value.eql?(number)
        return false
      end
    end

    row_start = row_index - row_index % 3
    column_start = column_index - column_index % 3

    box = fields.where(row: [row_start, row_start + 1, row_start + 2],
                       column: [column_start, column_start + 1, column_start + 2])
    box.each do |field|
      if field.value.eql?(number)
        return false
      end
    end
  end
end
