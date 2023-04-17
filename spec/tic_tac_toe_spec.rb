require './lib/tic_tac_toe'

describe Board do

  describe 'verify_input' do
    subject(:input_board) { described_class.new }
    context 'when player input is invalid' do
      it 'returns false' do
        player_input = '#'
        result = input_board.verify_input(player_input)
        expect(result).to be false
      end
    end
  end
  
end