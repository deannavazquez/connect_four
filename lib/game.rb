# Main CLI game loop (entry)
require_relative 'player'

class Game # rubocop:disable Style/Documentation
  RED = "\u{1F534}".freeze
  YELLOW = "\u{1F7E1}".freeze

  attr_accessor :board, :player1, :player2

  def initialize
    @board = create_board
    initialize_players
    @current_player_index = 0
  end

  def initialize_players
    @player1 = Player.new(1, Game::RED)
    @player2 = Player.new(2, Game::YELLOW)
  end

  def current_player
    [@player1, @player2][@current_player_index]
  end

  def switch_turn
    @current_player_index = (@current_player_index + 1) % [@player1, @player2].size
  end

  def create_board
    Array.new(6) { Array.new(7, ' ') }
  end

  def print_board
    puts '  0    1    2    3    4    5    6'
    sep = "+#{(['----'] * 7).join('+')}+"
    puts sep
    @board.each do |row|
      cells = row.map { |cell| cell == ' ' ? '  ' : cell }
      puts "| #{cells.join(' | ')} |"
      puts sep
    end
    puts
  end

  def valid_move?(col)
    (0..6).include?(col) && @board[0][col] == ' '
  end

  def add_piece(col)
    5.downto(0) do |row|
      if @board[row][col] == ' '
        @board[row][col] = current_player.color
        break
      end
    end
  end

  def player_turn
    loop do
      puts "Player #{current_player.number} - #{current_player.color} enter your move (col):"
      input = gets.chomp
      col = input.to_i

      if valid_move?(col)
        add_piece(col)
        print_board
        switch_turn
        break # exit loop after successful move
      else
        puts 'Invalid move, try again.'
      end
    end
  end

  def winner?
    @board.each do |row|
      row.each_cons(4) do |group|
        first = group.first
        return first if group.uniq.size == 1 && group.first != ' '
      end

      (0..6).each do |col|
        column = @board.map { |row| row[col] }
        column.each_cons(4) do |group|
          first = group.first
          return first if group.uniq.size == 1 && group.first != ' '
        end
      end

      (0..2).each do |r|
        (0..3).each do |c|
          group = [@board[r][c], @board[r + 1][c + 1], @board[r + 2][c + 2], @board[r + 3][c + 3]]
          first = group.first
          return first if group.uniq.size == 1 && group.first != ' '
        end
      end

      (3..5).each do |r|
        (0..3).each do |c|
          group = [@board[r][c], @board[r - 1][c + 1], @board[r - 2][c + 2], @board[r - 3][c + 3]]
          first = group.first
          return first if group.uniq.size == 1 && group.first != ' '
        end
      end
    end
    nil
  end

  def draw?
    @board[0].none? { |col| col == ' ' } && winner?.nil?
  end

  def play
    loop do
      print_board
      player_turn
      if winner = winner?
        print_board
        puts "Player #{winner} wins!"
        break
      elsif draw?
        print_board
        puts "It's a draw!"
        break
      end
    end
    puts 'Game over!'
  end
end

Game.new.play if __FILE__ == $PROGRAM_NAME
