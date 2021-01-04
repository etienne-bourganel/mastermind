# frozen_string_literal: true

# This is the class for all players
class Player
  attr_reader :score, :role, :name

  def initialize(role)
    @role = role
    @score = 0
  end
end

# For human player
class Human < Player
  def initialize(role)
    super(role)
    @name = set_human_name
  end

  def set_human_name
    puts "\nHello! What is your name?"
    gets.chomp.to_s
  end
end

# For machine player
class Machine < Player
  def initialize(role)
    super(role)
    @name = 'Machine'
  end
end
