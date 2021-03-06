# frozen_string_literal: true

require 'colorize'

# All messages to display in english
module Display
  def show_round(round)
    puts "\nRound #{round} of 10"
  end

  def start_game_welcome_human(name)
    puts "\n#{name}, try to guess the secret code"
  end

  def instructions
    puts "\nEnter your guess as a combination of 4 digits from 1 to 6, no space betwwen."
  end

  def display_winner_and_secret_code(winner, secret_code)
    print "\nThe #{winner} wins! The correct code was: "
    print_colorized_array(secret_code)
    print "\n"
  end

  def error_wrong_input_values
    puts 'ERROR - Enter numbers from 1 to 6 only'
  end

  def error_wrong_input_size
    puts 'ERROR - Enter exactly 4 numbers'
  end

  def display_player_score(player)
    # puts "\n#{player.name}'s score is #{player.score} as a #{player.role}."
    puts "\n#{player.name}/#{player.role}'s score: #{player.score}."
  end

  # Display array into more readable string
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

  # Set a color for each digit for better readability
  def colorize_integer_element(input)
    case input
    when 0
      ' 0 '.colorize(:light_black)
    when 1
      ' 1 '.colorize(:red)
    when 2
      ' 2 '.colorize(:white)
    when 3
      ' 3 '.colorize(:magenta)
    when 4
      ' 4 '.colorize(:green)
    when 5
      ' 5 '.colorize(:yellow)
    when 6
      ' 6 '.colorize(:cyan)
    end
  end

  # Format result to look mor elike colored pegs
  def transform_integer_to_peg(input)
    case input
    when 2
      ' o '.colorize(:red)
    when 1
      ' o '.colorize(:white)
    when 0
      ' - '.colorize(:light_black)
    end
  end

  def choices
    print "\nChoices: "
  end

  def codebreaker_guess
    print 'Guess: '
  end

  def codemaker_feedback
    print ' : '
  end
end
