# frozen_string_literal: true

# Contains flow of a game and game operations
class Game
  attr_reader :secret_code, :round
  COLORS = [1, 2, 3, 4, 5, 6].freeze # The "colors" ro play with
  def initialize
    create_players
    @secret_code = define_secret_code
    @guess = []
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

  # Condition to keep the codebreaker to continue guessing
  def continue?
    @round <= 10
  end

  # Round counter
  def update_round_counter
    @round += 1
  end

  # Flow for a game until one player wins
  def flow
    flow_start
    while continue?
      obtain_human_input
      print_colorized_array(@guess)
      update_round_counter
    end
  end

  # First instructions at the beginning of a game
  def flow_start
    Display.start_game_welcome_human(@human.name)
    print_colorized_array(@secret_code)
    Display.instructions
    Display.choices
  end

  # Obtaining human input and store it in @guess
  def obtain_human_input
    Display.show_round(@round)
    input = gets.chomp
    @guess = input.split(' ').map(&:to_i)
  end

  # Transform an array into a colorized string
  def print_colorized_array(ary)
    colorized_str = String.new
    (0..3).each do |i|
      colorized_str << colorize_input(ary[i])
    end
    print colorized_str
  end

  # Set a color for each digit for better readability
  def colorize_input(input)
    case input
    when nil
      ' - '
    when 1
      ' 1 '.colorize(:light_black)
    when 2
      ' 2 '.colorize(:magenta)
    when 3
      ' 3 '.colorize(:light_cyan)
    when 4
      ' 4 '.colorize(:green)
    when 5
      ' 5 '.colorize(:yellow)
    when 6
      ' 6 '.colorize(:red)
    end
  end
end
