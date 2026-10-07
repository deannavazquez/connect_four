require_relative '../lib/game'

describe Game do
  before do
    allow($stdout).to receive(:puts)
  end

  describe '#create_board' do
    subject(:game) { described_class.new }

    context 'when board is created' do
      it 'returns 6 arrays, holding 7 strings, each with a single space' do
        board = game.create_board
        expect(board).to eq([
                              [' ', ' ', ' ', ' ', ' ', ' ', ' '],
                              [' ', ' ', ' ', ' ', ' ', ' ', ' '],
                              [' ', ' ', ' ', ' ', ' ', ' ', ' '],
                              [' ', ' ', ' ', ' ', ' ', ' ', ' '],
                              [' ', ' ', ' ', ' ', ' ', ' ', ' '],
                              [' ', ' ', ' ', ' ', ' ', ' ', ' ']
                            ])
      end
    end
  end

  describe '#add_piece' do
    let(:game) { described_class.new }

    context 'when adding a piece to an empty board' do
      it 'drop in column 3 and piece lands in row 5' do
        game.add_piece(3)
        expect(game.board[5][3]).to eq(Game::RED)
      end

      it 'remainder rows stays empty' do
        game.add_piece(3)
        expect(game.board[4][3]).to eq(' ')
      end
    end

    context 'when a piece already exists in the column' do
      subject(:game) { described_class.new }

      before do
        game.board[5][3] = Game::RED
      end

      it 'piece lands in row 4' do
        game.add_piece(3)
        expect(game.board[4][3]).to eq(Game::RED)
      end
    end

    context 'when it is player 2\'s turn' do
      subject(:game) { described_class.new }

      before do
        game.switch_turn
      end

      it 'places a yellow piece in row 5' do
        game.add_piece(3)
        expect(game.board[5][3]).to eq(Game::YELLOW)
      end
    end
  end

  describe '#switch_turn' do
    subject(:game) { described_class.new }

    context 'when the game starts, current player is player 1' do
      it 'returns player 1' do
        expect(game.current_player).to eq(game.player1)
      end
    end

    context 'when it is player 1\'s turn' do
      it 'changes current player to player 2' do
        game.switch_turn
        expect(game.current_player).to eq(game.player2)
      end
    end

    context 'when the turn is switched twice' do
      it 'current player is 1' do
        game.switch_turn
        game.switch_turn
        expect(game.current_player).to eq(game.player1)
      end
    end
  end

  describe '#valid_move?' do
    context 'when a column is full' do
      subject(:game) { described_class.new }

      before do
        game.board[0][3] = Game::RED
      end

      it 'returns false' do
        expect(game.valid_move?(3)).to be(false)
      end
    end

    context 'when a column has room' do
      subject(:game) { described_class.new }

      before do
        game.board[0][2] = ' '
      end

      it 'returns true' do
        expect(game.valid_move?(2)).to be true
      end
    end

    context 'when the column is past the last column' do
      subject(:game) { described_class.new }

      it 'returns false' do
        expect(game.valid_move?(7)).to be false
      end
    end

    context 'when the column is -1' do
      subject(:game) { described_class.new }

      it 'returns false' do
        expect(game.valid_move?(-1)).to be false
      end
    end

    context 'when its the last column' do
      subject(:game) { described_class.new }

      it 'returns true' do
        expect(game.valid_move?(6)).to be true
      end
    end
  end

  describe '#player_turn' do
    context 'when the player enters a valid column' do
      subject(:game) { described_class.new }

      before do
        allow(game).to receive(:gets).and_return('3')
      end

      it 'the piece lands in row 5' do
        game.player_turn

        expect(game.board[5][3]).to eq(Game::RED)
      end

      it 'switches to player 2' do
        game.player_turn

        expect(game.current_player).to eq(game.player2)
      end
    end

    context 'when the player enters an invalid column, they get an error message and another try' do
      subject(:game) { described_class.new }

      before do
        allow(game).to receive(:gets).and_return('9', '3')
      end

      it 'returns message for invalid move' do
        expect { game.player_turn }.to output(/try again/).to_stdout
      end

      it 'adds piece for valid input on another try' do
        game.player_turn

        expect(game.board[5][3]).to eq(Game::RED)
      end
    end
  end

  describe '#winner?' do
    subject(:game) { described_class.new }

    context 'when the bottom row has four red pieces in a row' do
      before do
        game.board[5] = [' ', ' ', Game::RED, Game::RED, Game::RED, Game::RED, ' ']
      end

      it 'returns Game::RED' do
        expect(game.winner?).to eq(Game::RED)
      end
    end

    context 'when the bottom row has 1 yellow and 3 red' do
      before do
        game.board[5] = [' ', Game::YELLOW, Game::RED, Game::RED, Game::RED, ' ', ' ']
      end

      it 'returns nil' do
        expect(game.winner?).to be_nil
      end
    end

    context 'when column 3 has 4 red pieces stacked' do
      before do
        game.board[2][3] = Game::RED
        game.board[3][3] = Game::RED
        game.board[4][3] = Game::RED
        game.board[5][3] = Game::RED
      end

      it 'returns Game::RED' do
        expect(game.winner?).to eq(Game::RED)
      end
    end

    context 'when the left column has 1 yellow and 3 red stacked' do
      before do
        game.board[2][3] = Game::YELLOW
        game.board[3][3] = Game::RED
        game.board[4][3] = Game::RED
        game.board[5][3] = Game::RED
      end

      it 'returns nil' do
        expect(game.winner?).to be_nil
      end
    end

    context 'when a diagonal has 4 red in a row down and right' do
      before do
        game.board[2][0] = Game::RED
        game.board[3][1] = Game::RED
        game.board[4][2] = Game::RED
        game.board[5][3] = Game::RED
      end

      it 'returns red' do
        expect(game.winner?).to eq(Game::RED)
      end
    end

    context 'when a diagonal has 1 yellow 3 red in a row down and right' do
      before do
        game.board[2][0] = Game::YELLOW
        game.board[3][1] = Game::RED
        game.board[4][2] = Game::RED
        game.board[5][3] = Game::RED
      end

      it 'returns red' do
        expect(game.winner?).to be_nil
      end
    end

    context 'when a diagonal has 4 red in a row up and right' do
      before do
        game.board[5][0] = Game::RED
        game.board[4][1] = Game::RED
        game.board[3][2] = Game::RED
        game.board[2][3] = Game::RED
      end

      it 'returns red' do
        expect(game.winner?).to eq(Game::RED)
      end
    end

    context 'when a diagonal has 1 yellow 3 red in a row up and right' do
      before do
        game.board[5][0] = Game::YELLOW
        game.board[4][1] = Game::RED
        game.board[3][2] = Game::RED
        game.board[2][3] = Game::RED
      end

      it 'returns red' do
        expect(game.winner?).to be_nil
      end
    end
  end

  describe '#draw?' do
    context 'when the whole board is full' do
      subject(:game) { described_class.new }

      before do
        game.board[0] = [Game::RED, Game::YELLOW, Game::RED, Game::YELLOW, Game::RED, Game::YELLOW, Game::RED]
      end

      it 'returns true' do
        expect(game.draw?).to be(true)
      end
    end
  end

  describe '#play' do
    context 'when red stacks 4 pieces in column 3 and yellow drops others in between' do
      subject(:game) { described_class.new }

      before do
        allow(game).to receive(:gets).and_return('3', '4', '3', '4', '3', '4', '3')
      end

      it 'handles the input sequence without raising an error' do
        expect { game.play }.to output(/wins!/).to_stdout
      end
    end
  end
end
