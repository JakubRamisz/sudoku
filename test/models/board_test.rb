require "test_helper"

class BoardTest < ActiveSupport::TestCase

  test "should not save board without name" do
    board = Board.new
    assert_not board.save, "Saved board without a name"
  end

  test "should create a solved board" do
    board = Board.new(name: "test board")
    assert board.save, "Did not save the board"

    1.upto 9 do |number|
      0.upto 8 do |i|
        assert board.fields.where(row: i, value: number).size.eql?(1),
               "Wrong number of #{number} in row #{i}"

        assert board.fields.where(column: i, value: number).size.eql?(1),
               "Wrong number of #{number} in column #{i}"
      end

      0.upto 2 do |i|
        0.upto 2 do |j|
          assert board.fields.where(row: 3*i..3*i+2, column: 3*j..3*j+2, value: number).size.eql?(1),
                 "Wrong number of #{number} in box #{i} #{j}"
        end
      end
    end
  end

  test "should return true on solved board" do
    board = Board.new(name: "test board")
    board.save
    assert board.solved?, "Did not return true"
    end

  test "should return false on unsolved board" do
    board = Board.new(name: "test board")
    board.save
    board.fields.find_by(row: 0, column: 0).update(value: 0)
    board.save

    assert_not board.solved?, "Did not return false"
  end
end
