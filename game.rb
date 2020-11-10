# frozen_string_literal: true

# Contains flow of a game and game operations
class Game
  attr_reader :secret_code, :round
  COLORS = [1, 2, 3, 4, 5, 6].freeze
  def initialize
    create_players
    @secret_code = define_secret_code
    @round = 1
  end

  # Create both players
  def create_players
    @human = Human.new('codebreaker')
    @machine = Machine.new('codemaker')
  end

  # Create the secret code based on available colors
  def define_secret_code
    [COLORS.sample, COLORS.sample, COLORS.sample, COLORS.sample]
  end

  # Flow for a game until one player wins
  def flow
    Display.start_game_welcome_human(@human.name)
    print @secret_code
    while continue?
      human_input
      round_counter
    end
  end

  # Round counter
  def round_counter
    @round += 1
  end

  # Human input logic
  def human_input
    Display.show_round(@round)
    input = gets.chomp
    print input
  end

  # Condition to keep the codebreaker to continue guessing
  def continue?
    @round <= 10
  end

  # Generate feedback array based on guess
end
