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
  def add_one_round
    @round += 1
  end

  # Flow for a game until one player wins
  def flow
    flow_start
    while continue?
      obtain_human_input
      Display.codebreaker_guess
      print_colorized_array(@guess)
      update_feedback
      Display.codemaker_feedback
      print_colorized_array(@feedback)
      add_one_round
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
    str << Display.format_feedback(elmt)
    str
  end

  # Create a new string and add colorized strings
  def colorize_input(elmt)
    str = String.new
    str << Display.colorize_input(elmt)
    str
  end

  # Update @feedback based on @guess
  def update_feedback
    @feedback = [] # Reset @feedback each time
    count_correct_colors
    count_correct_positions
    add_pegs_and_spaces
    @feedback = @feedback.sort.reverse # Reorganize @feedback array for better readability
  end

  # Transform the array of colors into an hash with color id number as the key
  def transform_code_array_into_hash(ary)
    ary.group_by(&:itself).map { |k, v| [k, v.length] }.to_h
  end

  # Create a new hash with values calculated from difference between two hashes to spot differences
  def create_difference_hash(secret, guess)
    secret.merge(guess) { |_k, secret_color, guess_color| (secret_color - guess_color) }
  end

  # Create a new hash with only the secret code colors as keys
  def create_new_hash_with_correct_colors(hash, colors_ary)
    hash.delete_if { |k, _v| k unless colors_ary.include? k }
  end

  # Count the number of correct guessed colors
  def count_correct_colors
    secret_hash = transform_code_array_into_hash(@secret_code)
    guess_hash = transform_code_array_into_hash(@guess)
    difference_hash = create_difference_hash(secret_hash, guess_hash)
    secret_colors = secret_hash.keys # Create an array with the correct color codes
    difference_hash_with_secret_colors = create_new_hash_with_correct_colors(difference_hash, secret_colors)
    sum = 0
    difference_hash_with_secret_colors.each { |_k, v| sum += v if v.positive? } # Only positive differences are kept
    correct_colors = 4 - sum # sum is all the colors from secrets that have not been guessed
    correct_colors
  end

  # Count the number of correctly postionned colors
  def count_correct_positions
    correct_positions = 0
    (0..3).each do |i|
      correct_positions += 1 if @guess[i] == @secret_code[i]
    end
    correct_positions
  end

  # Add red pegs (value = 2) to @feedback
  def add_red_pegs
    x = count_correct_positions
    x.times { @feedback << 2 }
  end

  # Add white pegs (value = 1) to @feedback
  def add_white_pegs
    x = count_correct_colors - count_correct_positions
    x.times { @feedback << 1 }
  end

  # Add blank spaces (value = 0) to @feedback to have an array with 4 elements in total
  def add_blank_spaces
    x = 4 - count_correct_colors
    x.times { @feedback << 0 }
  end

  # Gather functions for better readability
  def add_pegs_and_spaces
    add_red_pegs
    add_white_pegs
    add_blank_spaces
  end
end
