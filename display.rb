# frozen_string_literal: true

require 'colorize'

# All messages to display in english
class Display
  def self.set_human_name
    puts "\nHello! What is your name?"
  end

  def self.show_round(round)
    puts "\nRound #{round} of 10"
  end

  def self.start_game_welcome_human(name)
    puts "\n#{name}, try to guess the secret code"
  end

  def self.instructions
    puts "\nEnter your guess as a combination of 4 digits separated by a space."
  end

  # Set a color for each digit for better readability
  def self.colorize_input(input)
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
  def self.format_feedback(input)
    case input
    when 2
      ' o '.colorize(:red)
    when 1
      ' o '.colorize(:white)
    when 0
      ' - '.colorize(:light_black)
    end
  end

  def self.choices
    print "\nChoices: "
  end

  def self.codebreaker_guess
    print 'Guess: '
  end

  def self.codemaker_feedback
    print ' : '
  end
end
