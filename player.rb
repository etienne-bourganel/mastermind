# frozen_string_literal: true

# This is the class for all players
class Player
  attr_reader :role, :name
  attr_accessor :score

  def initialize(role)
    @role = role
    @score = 0
  end
end

# For human player
class Human < Player
  def initialize(role, name = 'Human player')
    super(role)
    @name = name
  end
end

# For machine player
class Machine < Player
  def initialize(role)
    super(role)
    @name = 'Machine'
  end
end
