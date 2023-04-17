class Board
  def initialize
    @squares = [
      [' ', ' ', ' '],
      [' ', ' ', ' '],
      [' ', ' ', ' ']
    ]
  end

  def verify_input(input)
    input.match?(/^[xXoO]$/)
  end

end

class PlayerOne
end

class PlayerTwo
end