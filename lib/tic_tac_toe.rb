require_relative './drawings'

class Board
  attr_accessor :top, :middle, :bottom, :game_status, :x, :o, :piece_arr
  attr_reader :space, :section_top, :top_left_gap, :top_left_vert, :top_right_vert, :upper_horiz, :middle_left_gap, :middle_left_vert, :middle_right_vert, :lower_horiz, :bottom_left_gap, :bottom_left_vert, :bottom_right_vert, :section_bottom, :vert_left, :vert_middle, :vert_right, :diag_forward, :diag_back, :total, :total_2, :x1, :x2, :x3, :x4, :o1, :o2, :o3, :o4
  
  include Drawings

  def initialize
    add_drawings
    @game_status = "ongoing"
    @piece_arr = []

    @x = [@x1, @x2, @x3, @x4]
    @o = [@o1, @o2, @o3, @o4]

    @top = [@space, @space, @space]
    @middle = [@space, @space, @space]
    @bottom = [@space, @space, @space]
  end

  def assign_for_win_check
    @vert_left = [@top[0], @middle[0], @bottom[0]]
    @vert_middle = [@top[1], @middle[1], @bottom[1]]
    @vert_right = [@top[2], @middle[2], @bottom[2]]
    @diag_forward = [@bottom[0], @middle[1], @top[2]]
    @diag_back = [@top[0], @middle[1], @bottom[2]]
    @total = [@top, @middle, @bottom, @vert_left, @vert_middle, @vert_right, @diag_forward, @diag_back]
    @total_2 = [@top, @middle, @bottom]
  end

  def game_won?
    total.any?{|el| el.all? {|e| @piece_arr.include?(e)}}
  end

  def print_board_row (row, left_sp, left_div, right_div)
    left_sp.each_line.with_index do |line, index|
      puts line.strip + row[0].lines[index].strip + left_div.lines[index].strip + row[1].lines[index].strip + right_div.lines[index].strip + row[2].lines[index].strip
    end
  end
  
  def print_board
    puts section_top
    print_board_row(top, top_left_gap, top_left_vert, top_right_vert)
    puts upper_horiz
    print_board_row(middle, middle_left_gap, middle_left_vert, middle_right_vert)
    puts lower_horiz
    print_board_row(bottom, bottom_left_gap, bottom_left_vert, bottom_right_vert)
    puts section_bottom
  end

  def play_game
    system'clear'
    self.print_board
    player_switch = [1, 2]
    typo_str = "Typo. Try again."
    type = ''
    loop do
      puts 'Player 1 choose piece (X or O).'
      type = gets.chomp.downcase
      break if type == 'o' || type == 'x'
      puts typo_str
    end
    
    system'clear'
    self.print_board
    if type == "x"
      type_switch = [x[0], o[0]]
    elsif type == "o"
      type_switch = [o[0], x[0]]
    end
    
    until game_status == "victory" || game_status == "draw" do
      puts "Player #{player_switch[0]} move. State row followed by column e.g. \'top middle\'."
    
      position = gets.split
    
      case position[1]
      when "left"
        position[1] = 0
      when "middle"
        position[1] = 1
      when "right"
        position[1] = 2
      else
        puts typo_str
        redo
      end
    
      case position[0]
      when "top"
        x = top
      when "middle"
        x = middle
      when "bottom"
        x = bottom
      else
        puts typo_str
        redo
      end
    
      if x[position[1]] == space
        x[position[1]] = type_switch[0]
      else
        puts "Please choose an empty space."
        redo
      end
    
      if self.x.include?(type_switch[0])
        self.x.rotate!
        type_switch[0] = self.x[0]
        self.piece_arr = self.x
      elsif self.o.include?(type_switch[0])
        self.o.rotate!
        type_switch[0] = self.o[0]
        self.piece_arr = self.o
      end
    
      system'clear'
      self.print_board
    
      self.assign_for_win_check
    
      if self.game_won? then 
        puts "Player #{player_switch[0]} wins! Game over!"
        self.game_status = "victory"  
      elsif self.total_2.flatten.count(self.space) <= 2
        check_for_draw = Marshal.load( Marshal.dump(self))
        check_for_draw_2 = Marshal.load( Marshal.dump(self))
        draw_switch = type_switch
    
        def draw_check(board, draw_switch)
          2.times do
            if board.top.include?(board.space)
              board.top[board.top.index(board.space)] = draw_switch[0]
            elsif board.middle.include?(board.space)
              board.middle[board.middle.index(board.space)] = draw_switch[0]
            elsif board.bottom.include?(board.space)
              board.bottom[board.bottom.index(board.space)] = draw_switch[0]
            end
            draw_switch = draw_switch.reverse
          end
          board.assign_for_win_check
        end
    
        draw_check(check_for_draw, draw_switch)
        draw_switch = draw_switch.reverse
        draw_check(check_for_draw_2, draw_switch)
    
        if !check_for_draw.game_won? && !check_for_draw_2.game_won?
          puts "It's a draw. Game over."
          self.game_status = "draw"
        end
      end
    
      player_switch = player_switch.reverse
      type_switch = type_switch.reverse
    end
  end
end

Board.new.play_game
