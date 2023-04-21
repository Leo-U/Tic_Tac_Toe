class Board
  attr_accessor :current_piece
  attr_reader :state

  def initialize
    @current_piece = %w[x o]
    @state = [
    ['7', '8', '9'],
    ['4', '5', '6'],
    ['1', '2', '3']
    ]
  end
  
  # query method (don't test)
  def rows
    @state
  end

  # query method (don't test)
  def columns
    @state.transpose
  end

  # query method (test return values)
  def diagonals
    [
      [@state[0][0], @state[1][1], @state[2][2]],
      [@state[0][2], @state[1][1], @state[2][0]]
    ]
  end

  # query method and puts method, so test.
  def print_board
    puts " #{@state[0][0]} | #{@state[0][1]} | #{@state[0][2]}"
    puts '---|---|---'
    puts " #{@state[1][0]} | #{@state[1][1]} | #{@state[1][2]}"
    puts '---|---|---'
    puts " #{@state[2][0]} | #{@state[2][1]} | #{@state[2][2]}"
  end
end

class Game
  attr_accessor :board, :game_won, :chosen_square

  def initialize
    @chosen_square = nil
    @current_player = [1, 2]
    @game_won = false
    @game_drawn = false
    @board = Board.new
  end

  # don't test
  def ask_for_square
    puts "Player #{@current_player[0]}, type a number to choose a square to draw your symbol."
  end

  # don't test
  def print_typo_message
    puts "\nTYPO OR SQUARE OCCUPIED.\n"
  end

  # test this (done)
  def set_chosen_square
    @chosen_square = gets.to_i
  end

  # query method (test it!) (done)
  def occupied?
    @board.state.none? { |row| row.include?(@chosen_square.to_s) }
  end

  # command method (test it!) (done)
  def update_state
    @board.state.map! { |row| row.map { |num| @chosen_square.eql?(num) ? @board.current_piece[0].red : num } }
  end

  # test this (done)
  def input_verified?
    @chosen_square.to_s.match?(/^[1-9]$/)
  end

  # command method, test this (done)
  def set_game_won
    @game_won = (@board.rows + @board.columns + @board.diagonals).any? do |line|
      line.all?('o') || line.all?('x')
    end
  end

  # command method, test this
  def set_game_drawn
    @game_drawn = @board.state.all? { |row| row.values.none?(' ') } unless @game_won
  end

  # no test
  def print_game_over
    puts "Player #{@current_player[0]} wins!" if @game_won
    puts 'It\'s a draw!' if @game_drawn
  end

  # test loop behavior
  def choose_square
    until (input_verified? unless occupied?)
      ask_for_square
      set_chosen_square
      print_typo_message if (occupied? || !input_verified?)
    end
  end

  # only test nested methods
  def set_instance_variables
    update_state
    set_game_won
    set_game_drawn
  end

  def print_info
    board.print_board
    print_game_over
  end

  # command method, test it
  def reverse_arrays
    board.current_piece.reverse!
    @current_player.reverse!
  end

  # test loop behavior
  def play_game
    # board.print_board
    until @game_won || @game_drawn
      choose_square
      set_instance_variables
      print_info
      reverse_arrays
    end
  end
end

class String
  def red
    "\e[31m#{self}\e[0m"
  end
end
# game = Game.new

# game.play_game
