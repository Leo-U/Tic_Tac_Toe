require_relative '../lib/game'
require_relative '../lib/board'
require_relative '../lib/string'

describe Game do
  let(:rows) do
    [['7', '8', '9'],
     ['4', '5', '6'],
     ['1', '2', '3']]
 end

  describe '#set_chosen_square' do
    subject(:game_square) { described_class.new }
    it 'updates current square' do
      input = '5'
      allow(game_square).to receive(:gets).and_return(input)

      expect { game_square.set_chosen_square }.to change { game_square.instance_variable_get(:@chosen_square) }.to('5')
    end
  end

  describe '#input_verified?' do
    subject(:input_board) { described_class.new }

    context 'when input is invalid' do
      it 'returns false' do
        allow(input_board).to receive(:gets).and_return('#')
        input_board.set_chosen_square
        expect(input_board.input_verified?).to be false
      end
    end

    context 'when input is valid' do
      it 'returns true' do
        allow(input_board).to receive(:gets).and_return('4')
        input_board.set_chosen_square
        expect(input_board.input_verified?).to be true
      end
    end
  end

  describe '#occupied?' do
    subject(:game_occupied) { described_class.new }
    let(:board) { game_occupied.instance_variable_get(:@board) }

    context 'when chosen square is 5 and square is taken' do

      context 'when chosen square is taken by x' do
        it 'returns true' do
          rows[1][1] = 'x'.red
          chosen = '5'
          board.instance_variable_set(:@rows, rows)
          expect(board.occupied?(chosen)).to be true
        end
      end

      context 'when chosen square is taken by o' do
        it 'returns true' do
          rows[0][0] = 'o'.blue
          chosen = '7'
          board.instance_variable_set(:@rows, rows)
          expect(board.occupied?(chosen)).to be true
        end
      end
    end

    context 'when chosen square is 3 and square is not taken' do

      it 'returns false' do
        chosen = '3'
        board.instance_variable_set(:@rows, rows)
        expect(board.occupied?(chosen)).to be false
      end
    end
  end

  describe '#update_state' do
    subject(:game_state) { described_class.new }
    let(:board) { game_state.instance_variable_get(:@board) }

    before do
      rows[0][0] = 'x'.red
    end

    let(:chosen) { '7' }

    it 'updates state' do
      expect { board.update_state(chosen) }.to change { board.rows }.to(rows)
    end

    it 'does not update state when chosen square is taken' do
      board.instance_variable_set(:@rows, rows)
      expect { board.update_state(chosen) }.not_to change { board.rows }
    end
  end

  describe '#set_game_won' do
    subject(:game_win_check) { described_class.new }
    let(:board) { game_win_check.instance_variable_get(:@board) }

    it 'returns true when win condition is met' do
      rows[0][0], rows[1][1], rows[2][0], rows[2][1], rows[2][2] = 'x'.red, 'x'.red, 'o'.blue, 'o'.blue, 'x'.red
      board.instance_variable_set(:@rows, rows)
      result = game_win_check.set_game_won

      expect(result).to be true
    end

    it 'returns false when win condition is not met' do
      rows[1][1], rows[2][0], rows[2][1], rows[2][2] = 'x'.red, 'o'.blue, 'o'.blue, 'x'.red
      board.instance_variable_set(:@rows, rows)
      result = game_win_check.set_game_won

      expect(result).to be false
    end
  end

  describe '#set_game_drawn' do
    subject(:game_draw_check) { described_class.new }
    let(:board) { game_draw_check.instance_variable_get(:@board) }

    let(:rows) do
       [['x'.red, 'o'.blue, 'x'.red],
       ['x'.red, 'o'.blue, 'o'.blue],
       ['o'.blue, 'x'.red, 'x'.red]]
    end

    context 'when game is not won' do
      context 'when squares are all filled' do
        it 'returns true' do
          board.instance_variable_set(:@rows, rows)
          result = game_draw_check.set_game_drawn
          expect(result).to be true
        end
      end

      context 'when squares are not all filled' do
        it 'returns false' do
          rows[2][2] = '3'
          board.instance_variable_set(:@rows, rows)
          result = game_draw_check.set_game_drawn
          expect(result).to be false
        end
      end
    end

    context 'when game is won and squares are all filled' do
      it 'returns nil' do
        rows[2][0], rows[2][2] = 'x'.red, 'o'.blue
        board.instance_variable_set(:@rows, rows)
        game_draw_check.instance_variable_set(:@game_won, true)
        result = game_draw_check.set_game_drawn
        expect(result).to be_nil
      end
    end
  end
  
  describe '#choose_square' do
    subject(:game_choose_square) { described_class.new }
    let(:typo_message) { "\nTYPO OR SQUARE OCCUPIED.\n" }
    let(:board) { game_choose_square.instance_variable_get(:@board) }

    before do
      allow(game_choose_square).to receive(:ask_for_square)
    end

    context 'when wrong value is input & then correct value is input' do
      it 'prints typo message once and completes loop' do
        allow(game_choose_square).to receive(:gets).and_return('999', '3')

        expect(game_choose_square).to receive(:puts).with(typo_message).once
        game_choose_square.choose_square
      end
    end

    context 'when occupied square is input twice, & then correct value is input' do
      it 'prints typo message twice and completes loop' do
        rows[0][0], rows[1][1] = 'o'.blue, 'x'.red
        board.instance_variable_set(:@rows, rows)
        allow(game_choose_square).to receive(:gets).and_return('5', '7', '3')

        expect(game_choose_square).to receive(:puts).with(typo_message).twice
        game_choose_square.choose_square
      end
    end

    context 'when correct value is input' do
      it 'completes loop and does not print typo message' do
        allow(game_choose_square).to receive(:gets).and_return('3')
        expect(game_choose_square).not_to receive(:puts)
        game_choose_square.choose_square
      end
    end
  end

  describe '#change_player' do
    subject(:game_change_player) { described_class.new }

    it 'changes @current_player from 1 to 2 and from 2 to 1 when called again' do
      expect { game_change_player.change_player }.to change { game_change_player.instance_variable_get(:@current_player) }.by(1)

      expect { game_change_player.change_player }.to change { game_change_player.instance_variable_get(:@current_player) }.by(-1)
    end
  end

  describe '#play_game' do
    subject(:game_play) { described_class.new }

    context 'when move sequence is made that draws the game' do
      it 'completes loop and draws the game' do
        allow(game_play).to receive(:gets).and_return('1', '4', '5', '9', '2', '3', '6', '8', '7')
        expect{ game_play.play_game }.to change { game_play.instance_variable_get(:@game_drawn) }.to true
      end
    end

    context 'when move sequence is made that wins the game' do
      it 'completes the loop and wins the game' do
        allow(game_play).to receive(:gets).and_return('5', '1', '7', '2', '3')
        expect{ game_play.play_game }.to change { game_play.instance_variable_get(:@game_won) }.to true
      end
    end
  end
end

describe Board do
  subject(:test_state_board) { described_class.new }

  before do
    rows = [
      ['x'.red, 'o'.blue, 'o'.blue],
      ['o'.blue, 'x'.red, 'x'.red],
      ['o'.blue, 'x'.red, 'x'.red]
      ]
    test_state_board.instance_variable_set(:@rows, rows)
  end

  describe '#diagonals' do
    it 'returns the correct diagonals' do
      diagonals = test_state_board.diagonals
      expect(diagonals).to eq([['x'.red, 'x'.red, 'x'.red], ['o'.blue, 'x'.red, 'o'.blue]])
    end
  end

  describe '#change_piece' do
    subject(:board_change_piece) { described_class.new }

    it 'rotates the piece array' do
      expect { board_change_piece.change_piece }.to change { board_change_piece.instance_variable_get(:@current_piece) }.to(['o'.blue, 'x'.red])
    end
  end
end
