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

  def self.choices
    puts  "\nChoices:" + ' 1 '.colorize(:light_black) +
          ' 2 '.colorize(:magenta) +
          ' 3 '.colorize(:light_cyan) +
          ' 4 '.colorize(:green) +
          ' 5 '.colorize(:yellow) +
          ' 6 '.colorize(:red)
  end

end
