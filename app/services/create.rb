class Create
  def initialize(params)
    @params = params
  end

  def call
    create_board_with_fields
  end

  private
  def create_board_with_fields
    board = Board.create!(@params)

    0.upto 8 do |row|
      0.upto 8 do |column|
        board.fields.create(value: 0, row: row, column: column)
      end
    end
    board.solve
  end

end