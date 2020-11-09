# frozen_string_literal: true

# This is the class for all players, whether a human or a machine
class Player
  attr_reader :score, :role

  def initialize(role)
    @role = role
    @score = 0
  end
end

# For human player
class Human < Player
  attr_reader :name
  def initialize(role)
    super(role)
    @name = set_human_name
  end

  def set_human_name
    Display.set_human_name
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
