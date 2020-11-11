# frozen_string_literal: true

# Contains flow of a game and game operations
class Game
  attr_reader :secret_code, :round
  COLORS = [1, 2, 3, 4, 5, 6].freeze # The "colors" ro play with
  def initialize
    create_players
    @secret_code = define_secret_code
    @guess = []
    @feedback = []
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
      Display.codebreaker_guess
      print_colorized_array(@guess)
      feedback_on_guess
      Display.codemaker_feedback
      print_colorized_array(@feedback)
      update_round_counter
    end
  end

  # First instructions at the beginning of a game
  def flow_start
    Display.start_game_welcome_human(@human.name)
    print_colorized_array(@secret_code)
    Display.choices
    print_colorized_array(COLORS)
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
    l = ary.length - 1
    (0..l).each do |i|
      if ary == @feedback
        colorized_str << Display.format_feedback(ary[i])
      else colorized_str << Display.colorize_input(ary[i])
      end
    end
    print colorized_str
  end

  # Return a specific peg depending on condition
  def feedback_peg(idx)
    if @secret_code[idx] == @guess[idx]
      1
    elsif @guess.include?(@secret_code[idx]) && @secret_code[idx] != @guess[idx]
      2
    else 0
    end
  end

  # Reset @feedback and add pegs to @feedback array
  def feedback_on_guess
    @feedback = []
    (0..3).each do |i|
      @feedback << feedback_peg(i)
    end
    @feedback
  end
end
