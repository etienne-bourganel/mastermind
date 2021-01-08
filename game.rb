# frozen_string_literal: true

require_relative 'display'
require_relative 'analyze'
require_relative 'player'
require 'pry'

# Contains flow of a game and game operations
class Game
  include Display
  include Analyze
  attr_reader :secret_code, :round, :guess
  COLORS = [1, 2, 3, 4, 5, 6].freeze # The "colors" to play with
  def initialize
    set_human_name
  end

  # Ask for human player name and calls choice making
  def set_human_name
    puts 'Hello, what is your name?'
    human_name = gets.chomp.to_s
    make_role_choice(human_name)
  end

  # Prompt human player for name and tole, then triggers players creations
  def make_role_choice(human_name)
    puts "Hi there #{human_name}! Enter b to play as the codeBreaker or m to play as the codeMaker."
    choice = gets.chomp.to_s
    if %w[b m].include?(choice)
      create_players(choice, human_name)
    else make_role_choice(human_name)
    end
  end

  # Start the game flow corresponding to the chosen roles
  def start_correct_game_flow
    if @human.role == 'codebreaker'
      game_flow_human_codebreaker
    else game_flow_human_codemaker
    end
  end

  # Create both players
  def create_players(choice, human_name)
    if choice == 'b'
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
    @round <= 10 && @guess != @secret_code
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

  # Verify if any player is winning and trigger appropriate logic
  def check_and_manage_winner
    if codebreaker_wins?
      manage_codebreaker_winning_guess
    else manage_codemaker_wins
    end
  end

  # Flow for one game with the human player as the codebreaker
  def game_flow_human_codebreaker
    @secret_code = define_secret_code
    game_start_human_codebreaker
    while continue?
      one_round_human_codebreaker
      add_one_round
    end
    end_of_game_logic
  end

  # Check if there is a winner and if player wants to play a new round
  def end_of_game_logic
    check_and_manage_winner
    show_winner_and_scores
    new_round?
  end

  # Ask player for a new round
  def new_round?
    puts 'Want to play another round? Press y for yes or n for no'
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

  # One round where human player plays as the codebreaker
  def one_round_human_codebreaker
    show_round(@round)
    obtain_human_input
    codebreaker_guess
    print_colorized_array(@guess)
    update_feedback
    codemaker_feedback
    print_colorized_array(@feedback)
  end

  # Game flow where human player plays as the codemaker
  def game_flow_human_codemaker
    game_start_human_codemaker
    while continue?
      one_round_human_codemaker
      add_one_round
    end
    end_of_game_logic
  end

  # One round where human player plays as the codemaker
  def one_round_human_codemaker
    show_round(@round)
    puts 'The machine is thinking...'
    sleep 1
    @guess = define_secret_code
    print_colorized_array(@guess)
  end

  # What to do when a game starts with human as the codemaker
  def game_start_human_codemaker
    reset_instance_variables_values
    set_secret_code
    puts 'The secret code is: '
    print_colorized_array(@secret_code)
  end

  # Human codemaker to create a secret code + verification for valid code
  def set_secret_code
    puts 'Enter a 4-digit code, each digit from 1 to 6.'
    input = gets.chomp
    @secret_code = input.split('').map(&:to_i)
    return unless wrong_input(@secret_code) == true

    input_error_messages(@secret_code)
    set_secret_code
  end

  # Reset values for instance variables
  def reset_instance_variables_values
    @guess = []
    @feedback = []
    @round = 1
    @winner = ''
  end

  # What to do when a game start with human as the codebreaker
  def game_start_human_codebreaker
    reset_instance_variables_values
    start_game_welcome_human(@human.name)
    choices
    print_colorized_array(COLORS)
  end

  # Obtaining human input and store it in @guess if valid
  def obtain_human_input
    input = gets.chomp
    @guess = input.split('').map(&:to_i)
    return unless wrong_input(@guess) == true

    input_error_messages(@guess)
    obtain_human_input
  end

  # What error message to show
  def input_error_messages(input_ary)
    if correct_color_input?(input_ary, COLORS) == false
      error_wrong_input_values
    elsif correct_input_size?(input_ary, 4) == false
      error_wrong_input_size
    end
  end

  # Group conditions for inadequate input
  def wrong_input(input_ary)
    correct_input_size?(input_ary, 4) == false || correct_color_input?(input_ary, COLORS) == false
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
