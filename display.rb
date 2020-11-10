# frozen_string_literal: true

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
end
