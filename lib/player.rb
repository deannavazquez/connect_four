class Player
  attr_accessor :number, :color

  def initialize(number, color)
    @number = number
    @color = color
  end

  def print_player_color
    "Player #{@number} is #{@color}"
  end
end
