# frozen_string_literal: true

# manages the game logic, user interactions, and game states.
class Game
  def initialize
    @chosen_square = nil
    @current_player = 1
    @game_won = false
    @game_drawn = false
    @board = Board.new
  end

  def play_game
    @board.print_board
    until @game_won || @game_drawn
      choose_square
      set_instance_variables
      print_info
      @board.change_piece
      change_player
    end
  end

  def choose_square
    until (input_verified? unless @board.occupied?(@chosen_square))
      ask_for_square
      set_chosen_square
      print_typo_message if @board.occupied?(@chosen_square) || !input_verified?
    end
  end

  def input_verified?
    @chosen_square.to_s.match?(/^[1-9]$/)
  end

  def set_chosen_square
    @chosen_square = gets.chomp
  end

  def set_instance_variables
    @board.update_state(@chosen_square)
    set_game_won
    set_game_drawn
  end

  def set_game_won
    @game_won = (@board.rows + @board.columns + @board.diagonals).any? do |line|
      line.all?('o'.blue) || line.all?('x'.red)
    end
  end

  def set_game_drawn
    return if @game_won

    @game_drawn = @board.rows.all? do |row|
      row.none? { |value| value.match?(/^[1-9]$/) }
    end
  end

  def change_player
    @current_player.eql?(1) ? @current_player += 1 : @current_player -= 1
  end

  private

  def ask_for_square
    puts "Player #{@current_player}, type a number to choose a square to draw your symbol."
  end

  def print_typo_message
    puts "\nTYPO OR SQUARE OCCUPIED.\n"
  end

  def print_game_over
    puts "Player #{@current_player} wins!" if @game_won
    puts 'It\'s a draw!' if @game_drawn
  end

  def print_info
    @board.print_board
    print_game_over
  end
end
