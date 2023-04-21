# frozen_string_literal: true

# stores board state
class Board
  attr_reader :rows

  def initialize
    @current_piece = ['x'.red, 'o'.blue]
    @rows = [
      %w[7 8 9],
      %w[4 5 6],
      %w[1 2 3]
    ]
  end

  def columns
    @rows.transpose
  end

  def diagonals
    [
      [@rows[0][0], @rows[1][1], @rows[2][2]],
      [@rows[0][2], @rows[1][1], @rows[2][0]]
    ]
  end

  def print_board
    print_row(@rows[0])
    puts '---|---|---'
    print_row(@rows[1])
    puts '---|---|---'
    print_row(@rows[2])
  end

  def change_piece
    @current_piece.reverse!
  end

  def occupied?(chosen)
    @rows.none? { |row| row.include?(chosen) }
  end

  def update_state(chosen)
    @rows.map! { |row| row.map { |square| chosen.eql?(square) ? @current_piece[0] : square } }
  end

  private

  def print_row(row)
    puts " #{row[0]} | #{row[1]} | #{row[2]}"
  end
end
