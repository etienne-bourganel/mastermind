# frozen_string_literal: true
require_relative 'display'

# Contains flow of a game and game operations
class Game
  include Display
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
  def add_one_round
    @round += 1
  end

  # Flow for a game until one player wins
  def flow
    flow_start
    while continue?
      show_round(@round)
      obtain_human_input
      codebreaker_guess
      print_colorized_array(@guess)
      update_feedback
      codemaker_feedback
      print_colorized_array(@feedback)
      add_one_round
    end
  end

  # First instructions at the beginning of a game
  def flow_start
    start_game_welcome_human(@human.name)
    print_colorized_array(@secret_code)
    choices
    print_colorized_array(COLORS)
  end

  # Obtaining human input and store it in @guess
  def obtain_human_input
    input = gets.chomp
    @guess = input.split('').map(&:to_i)
    return unless wrong_input == true

    if correct_color_input?(@guess, COLORS) == false
      error_wrong_input_values
    elsif correct_input_size?(@guess, 4) == false
      error_wrong_input_size
    end
    obtain_human_input
  end

  # Group conditions for inadequate input
  def wrong_input
    correct_input_size?(@guess, 4) == false || correct_color_input?(@guess, COLORS) == false
  end

  # Return true if an array only contains certain values
  def correct_color_input?(input_ary, ref_ary)
    (input_ary - ref_ary).empty?
  end

  # Return true if an array contains a certain number fo elements
  def correct_input_size?(input_ary, ref_size)
    input_ary.length == ref_size
  end

  # Format array into more readable string
  def print_colorized_array(ary)
    l = ary.length - 1
    (0..l).each do |i|
      if ary == @feedback
        print format_feedback(ary[i])
      else print colorize_input(ary[i])
      end
    end
  end

  # Create a new string and add formatted strings
  def format_feedback(elmt)
    str = String.new
    str << transform_integer_to_peg(elmt)
    str
  end

  # Create a new string and add colorized strings
  def colorize_input(elmt)
    str = String.new
    str << colorize_integer_element(elmt)
    str
  end

  # Update @feedback based on @guess
  def update_feedback
    @feedback = [] # Reset @feedback each time
    Analyze.count_correct_colors(@secret_code, @guess)
    Analyze.count_correct_positions(@guess, @secret_code)
    add_pegs_and_spaces
    @feedback = @feedback.sort.reverse # Reorganize @feedback array for better readability
  end

  # Add red pegs (value = 2) to @feedback
  def add_red_pegs
    x = Analyze.count_correct_positions(@guess, @secret_code)
    x.times { @feedback << 2 }
  end

  # Add white pegs (value = 1) to @feedback
  def add_white_pegs
    x = Analyze.count_correct_colors(@secret_code, @guess) - Analyze.count_correct_positions(@guess, @secret_code)
    x.times { @feedback << 1 }
  end

  # Add blank spaces (value = 0) to @feedback to have an array with 4 elements in total
  def add_blank_spaces
    x = 4 - Analyze.count_correct_colors(@secret_code, @guess)
    x.times { @feedback << 0 }
  end

  # Gather functions for better readability
  def add_pegs_and_spaces
    add_red_pegs
    add_white_pegs
    add_blank_spaces
  end
end
