# frozen_string_literal: true

require_relative 'display'
require_relative 'analyze'
require 'pry'

# Contains flow of a game and game operations
class Game
  include Display
  include Analyze
  attr_reader :secret_code, :round, :guess
  COLORS = [1, 2, 3, 4, 5, 6].freeze # The "colors" to play with
  def initialize
    make_role_choice
  end

  # Prompt human player for name and tole, then triggers players creations
  def make_role_choice
    puts 'Hello, what is your name?'
    human_name = gets.chomp.to_s
    puts "#{human_name} Please, enter 1 to play as the codebreaker or 2 to play as the codemaker."
    choice = gets.chomp.to_i
    if choice == (1 || 2)
      create_players(choice, human_name)
    else make_role_choice
    end
  end

  # Start the game flow corresponding to the chosen roles
  def start_correct_game_flow
    return unless @human.role == 'codebreaker'

    start_game_flow_human_codebreaker
  end

  # Create both players
  def create_players(choice, human_name)
    if choice == 1
      @human = Human.new('codebreaker', human_name)
      @machine = Machine.new('codemaker')
    else
      @human = Human.new('codemaker', human_name)
      @machine = Machine.new('codebreaker')
    end
  end

  # Create the secret code based on available colors
  def define_secret_code
    [COLORS.sample, COLORS.sample, COLORS.sample, COLORS.sample]
  end

  # Condition to keep the codebreaker to continue guessing
  def continue?
    @round <= 10 && codebreaker_wins? == false
  end

  # Boolean to check if codebreaker guessed right
  def codebreaker_wins?
    return false unless @guess == @secret_code

    true
  end

  # What to do if the codebreaker wins
  def manage_codebreaker_winning_guess
    @winner = 'codebreaker'
    if @human.role.to_s == 'codebreaker'
      @human.score += 1
    else @machine.score += 1
    end
  end

  # What to do when the codemaker wins
  def manage_codemaker_wins
    @winner = 'codemaker'
    if @machine.role.to_s == 'codemaker'
      @machine.score += 1
    else @human.score += 1
    end
  end

  # show winner and scores
  def show_winner_and_scores
    display_winner_and_secret_code(@winner, @secret_code)
    display_player_score(@human)
    display_player_score(@machine)
  end

  # Round counter
  def add_one_round
    @round += 1
  end

  # Flow for one game with the human player as the codebreaker
  def start_game_flow_human_codebreaker
    round_start
    while continue?
      one_round
      add_one_round
    end
    if codebreaker_wins?
      manage_codebreaker_winning_guess
    else manage_codemaker_wins
    end
    show_winner_and_scores
    new_round?
  end

  # Ask player for a new round
  def new_round?
    puts 'Want to play another round? Press Y for yes or N for no'
    input = gets.chomp.to_s
    if input == 'y'
      sleep 1
      start_correct_game_flow
    elsif input == 'n'
      puts 'Ok, thanks for playing!'
      sleep 1
    else new_round?
    end
  end

  # Flow for a game until one player wins
  def one_round
    show_round(@round)
    obtain_human_input
    codebreaker_guess
    print_colorized_array(@guess)
    update_feedback
    codemaker_feedback
    print_colorized_array(@feedback)
  end

  # First instructions at the beginning of a game and reset of secret code and round number
  def round_start
    @secret_code = define_secret_code
    @guess = []
    @feedback = []
    @round = 1
    @winner = ''
    start_game_welcome_human(@human.name)
    choices
    print_colorized_array(COLORS)
  end

  # Obtaining human input and store it in @guess if valid
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

  # Update @feedback based on @guess
  def update_feedback
    @feedback = [] # Reset @feedback each time
    count_correct_colors(@secret_code, @guess)
    count_correct_positions(@guess, @secret_code)
    add_pegs_and_spaces
    @feedback = @feedback.sort.reverse # Reorganize @feedback array for better readability
  end

  # Add red pegs (value = 2) to @feedback
  def add_red_pegs
    x = count_correct_positions(@guess, @secret_code)
    x.times { @feedback << 2 }
  end

  # Add white pegs (value = 1) to @feedback
  def add_white_pegs
    x = count_correct_colors(@secret_code, @guess) - count_correct_positions(@guess, @secret_code)
    x.times { @feedback << 1 }
  end

  # Add blank spaces (value = 0) to @feedback to have an array with 4 elements in total
  def add_blank_spaces
    x = 4 - count_correct_colors(@secret_code, @guess)
    x.times { @feedback << 0 }
  end

  # Group functions for better readability
  def add_pegs_and_spaces
    add_red_pegs
    add_white_pegs
    add_blank_spaces
  end
end
